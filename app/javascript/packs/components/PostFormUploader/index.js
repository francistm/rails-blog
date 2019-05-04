import React, { PureComponent } from 'react'
import { from, fromEvent } from 'rxjs/index'
import { concatMap, map, mergeMap } from 'rxjs/operators/index'
import PropTypes from 'prop-types'
import { randomBytes } from 'crypto-browserify'
import UploadFile from './UploadFile'
import Axios from 'axios'
import { FILE_DESTROYED_EVENT_TYPE, FILE_INSERT_EVENT_TYPE, FILE_UPLOAD_SUCCEED_EVENT_TYPE } from './events'
import { insertIntoInputCaret } from './utils'

export function deserializeUploadFileStructFromJSON (rawObject) {
  return {
    id: rawObject.signed_gid,
    isImage: rawObject.is_image,
    byteSize: rawObject.byte_size,
    filename: rawObject.filename,
    signedId: rawObject.signed_id,
    signedGid: rawObject.signed_gid,
    blobPath: rawObject.blob_path,
    className: rawObject.class_name,
  }
}

export default class PostFormUploadComponent extends PureComponent {
  constructor (props) {
    super(props)

    this.state = {
      uploadFileList: [],
      uploadFileListLoading: false,
    }

    this.fileSelector = React.createRef()
    this.fileItemEventEmitter = new EventTarget()
  }

  static get propTypes () {
    return {
      postId: PropTypes.string.isRequired,
      postContentNode: PropTypes.instanceOf(HTMLTextAreaElement),
      directUploadUrl: PropTypes.string.isRequired,
    }
  }

  componentDidMount () {
    const { postId, postContentNode } = this.props

    fromEvent(this.fileSelector.current, 'change')
      .pipe(
        map((event) => (event.target.files)),
        mergeMap((fileList) => from(fileList)),
        map((file) => ({
          file: file,
          uniqueId: randomBytes(16).toString('hex'),
        }))
      )
      .subscribe((fileStruct) => {
        this.setState((prevState) => ({
          uploadFileList: [].concat(prevState.uploadFileList, [fileStruct]),
        }))
      })

    fromEvent(this.fileItemEventEmitter, FILE_DESTROYED_EVENT_TYPE)
      .pipe(
        map((event) => event.detail),
        concatMap((eventDetail) => {
          const promise = Axios.delete('/admins/posts/uploads.json', {
            params: {
              signed_gid: eventDetail.postUpload.signedGid,
            },
            headers: {
              'X-CSRF-Param': $('meta[name="csrf-param"]').attr('content'),
              'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content'),
            }
          }).then(() => {
            return eventDetail.uniqueId
          })

          return from(promise)
        })
      )
      .subscribe((uniqueId) => {
        this.setState((prevState) => {
          const { uploadFileList } = prevState
          const listIndex = uploadFileList.findIndex((postUpload) => {
            return uniqueId === postUpload.uniqueId
          })

          if (listIndex > -1) {
            const changedUploadFileList = [].concat(uploadFileList)
            changedUploadFileList.splice(listIndex, 1)

            return {
              ...prevState,
              uploadFileList: changedUploadFileList,
            }
          }
        })
      })

    fromEvent(this.fileItemEventEmitter, FILE_UPLOAD_SUCCEED_EVENT_TYPE)
      .pipe(
        map((e) => (e.detail)),
        concatMap((eventDetail) => {
          const promise = Axios
            .get('/admins/posts/retrieve-upload-blob.json', {
              params: {
                signed_id: eventDetail.signedId,
              },
            })
            .then((axiosResponse) => {
              return {
                uniqueId: eventDetail.uniqueId,
                postUpload: deserializeUploadFileStructFromJSON(axiosResponse.data),
              }
            })

          return from(promise)
        })
      )
      .subscribe(({ postUpload, uniqueId }) => {
        this.setState((prevState) => {
          const { uploadFileList } = prevState
          const uploadFileListIndex = uploadFileList.findIndex((uploadFile) => {
            return uniqueId === uploadFile.uniqueId
          })

          if (uploadFileListIndex === -1) {
            return prevState
          }

          const changedUploadFileList = [].concat(uploadFileList)

          changedUploadFileList[uploadFileListIndex] = {
            uniqueId: uniqueId,
            postUpload: postUpload,
          }

          return {
            ...prevState,
            uploadFileList: changedUploadFileList,
          }
        })
      })

    fromEvent(this.fileItemEventEmitter, FILE_INSERT_EVENT_TYPE)
      .pipe(map((e) => (e.detail)))
      .subscribe(({ postUpload }) => {
        insertIntoInputCaret(postContentNode, (selectedContent) => {
          const hrefOrSrc = postUpload.blobPath;
          const contentOrAlt = selectedContent ? selectedContent : postUpload.filename;

          if (!postUpload.isImage) {
            return `\n\n[${contentOrAlt}](${hrefOrSrc})\n\n`
          } else {
            return `\n\n![${contentOrAlt}](${hrefOrSrc})\n\n`
          }
        })
      })

    if (postId !== '') {
      Axios
        .get(`/admins/posts/${postId}/uploads.json`)
        .then((axiosResponse) => {
          this.setState((prevState) => {
            return {
              ...prevState,
              uploadFileList: axiosResponse.data.map(rawPostUpload => {
                return {
                  uniqueId: randomBytes(16).toString('hex'),
                  postUpload: deserializeUploadFileStructFromJSON(rawPostUpload)
                }
              }),
            }
          })
        })
    }
  }

  render () {
    const { directUploadUrl } = this.props
    const { uploadFileList, uploadFileListLoading } = this.state

    return <table id="uploads-table" className="table">
      <thead>
      <tr>
        <td>#</td>
        <td>文件名</td>
        <td>文件大小</td>
        <td>操作</td>
      </tr>
      </thead>

      <tbody>
      {uploadFileListLoading && (
        <tr>
          <td colSpan="4" className="text-center">正在加载</td>
        </tr>
      )}

      {(!uploadFileListLoading && uploadFileList.length === 0) && (
        <tr>
          <td colSpan="4" className="text-center">暂无文件</td>
        </tr>
      )}

      {uploadFileList.length > 0 && uploadFileList.map((postUpload) => (
        <UploadFile key={postUpload.uniqueId}
                    uniqueId={postUpload.uniqueId}
                    directUploadUrl={directUploadUrl}
                    fileItemEventEmitter={this.fileItemEventEmitter}

                    file={postUpload.file}
                    postUpload={postUpload.postUpload}
        />
      ))}
      </tbody>

      <tfoot>
      <tr>
        <td className="text-right" colSpan="4">
          <div className="btn btn-primary file-hidden-input-container">
            <input id="post_uploads" ref={this.fileSelector} type="file" multiple className="file-hidden-input"/>
            <span className="btn-text">选择文件</span>
          </div>
        </td>
      </tr>
      </tfoot>
    </table>
  }
}
