import React from "react"
import QueryString from "querystring"
import {EMPTY, from, fromEvent, of} from "rxjs"
import {catchError, concatMap, map, mergeMap} from "rxjs/operators"
import {ajax} from "rxjs/ajax"
import PropTypes from "prop-types"
import {DirectUpload} from "activestorage"

const ajaxGetJSONHeader = {
  'Content-Type': 'application/json; charset=utf8',
}

class FileInsert extends CustomEvent {
  constructor (attachment) {
    super('FileInsert')
    this._attachment = attachment
  }

  get attachment () {
    return this._attachment
  }
}

class FileDestroyed extends CustomEvent {
  constructor (attachment) {
    super('FileDestroyed')
    this._attachment = attachment
  }

  get attachment () {
    return this._attachment
  }
}

class FileUploadFailed extends CustomEvent {
  constructor (file, error) {
    super('FileUploadFailed')
    this._file = file
    this._error = error
  }

  get file () {
    return this._file
  }

  get error () {
    return this._error
  }
}

class FileUploadSucceed extends CustomEvent {
  constructor (file, signedId) {
    super('FileUploadSucceed')
    this._file = file
    this._signedId = signedId
  }

  get file () {
    return this._file
  }

  get signedId () {
    return this._signedId
  }
}

class UploadFile extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      file: props.file,
      attachment: props.attachment,

      uploadProgress: 0,
    }

    this.uploadEventEmitter = new EventTarget()
    this.insertButtonHandler = this.insertButtonHandler.bind(this)
  }

  static get propTypes() {
    return {
      index: PropTypes.number.isRequired,
      directUploadUrl: PropTypes.string.isRequired,
      fileItemEventEmitter: PropTypes.instanceOf(EventTarget),

      file: PropTypes.instanceOf(File),
      attachment: PropTypes.shape({
        id: PropTypes.number.isRequired,
        byteSize: PropTypes.number.isRequired,
        filename: PropTypes.string.isRequired,
        isImage: PropTypes.bool.isRequired,
        signedId: PropTypes.string.isRequired,
        blobPath: PropTypes.string.isRequired,
      }),
      attachmentPersisted: PropTypes.bool,
    }
  }

  static formatFileSize(size) {
    const unit = ['B', 'KB', 'MB', 'GB']
    const base = Math.floor(Math.log10(size))
    const unitBase = Math.round(Math.log(base) / Math.log(3))

    return [(size / Math.pow(1000, unitBase)).toFixed(2), unit[unitBase]].join(' ')
  }

  componentDidMount() {
    if (this.state.file) {
      const directUpload = new DirectUpload(this.props.file, this.props.directUploadUrl, this)

      directUpload.create((err, blob) => {
        if (err) {
          this.uploadEventEmitter.dispatchEvent(new FileUploadFailed(this.state.file, err))
        }
        else {
          this.uploadEventEmitter.dispatchEvent(new FileUploadSucceed(this.state.file, blob.signed_id))
        }
      })
    }

    fromEvent(this.uploadEventEmitter, 'FileUploadFailed')
      .subscribe((event) => {
      })

    fromEvent(this.uploadEventEmitter, 'FileUploadSucceed')
      .pipe(
        concatMap((uploadSucceedEvent) => ajax.getJSON(`/admins/posts/uploads?signed_id=${uploadSucceedEvent.signedId}`)),
        map((attachment) => {
          return {
            id: attachment.id,
            byteSize: attachment.byte_size,
            filename: attachment.filename,
            isImage: attachment.is_image,
            signedId: attachment.signed_id,
            blobPath: attachment.blob_path,
          }
        })
      )
      .subscribe((attachment) => {
        this.setState({
          file: null,
          attachment: attachment,
        })
      })
  }

  insertButtonHandler (event, attachment) {
    this.props.fileItemEventEmitter.dispatchEvent(new FileInsert(attachment))

    event.preventDefault()
  }

  destroyButtonHandler (event, attachment) {
    this.props.fileItemEventEmitter.dispatchEvent(new FileDestroyed(attachment))

    event.preventDefault()
  }

  // Hook for ActionStorage DirectUpload, DO NOT change the method name
  // Upload progress update with event
  directUploadWillStoreFileWithXHR(request) {
    fromEvent(request.upload, "progress")
      .pipe(map((e) => ({total: e.total, loaded: e.loaded})))
      .subscribe((progress) => {
        this.setState({uploadProgress: progress.loaded / progress.total})
      })
  }

  render() {
    if (this.state.file) {
      return <tr>
        <td>{this.props.index}</td>
        <td>{this.state.file.name}</td>
        <td>{this.constructor.formatFileSize(this.state.file.size)}</td>
        <td>
          <div className="progress mb0">
            <div className="progress-bar" style={{width: this.state.uploadProgress * 100 + '%'}}/>
          </div>
        </td>
      </tr>
    }
    else if (this.state.attachment) {
      return <tr>
        <td>{this.props.index}</td>
        <td>{this.state.attachment.filename}</td>
        <td>{this.constructor.formatFileSize(this.state.attachment.byteSize)}</td>
        <td>
          <div>
            <button onClick={(e) => this.insertButtonHandler(e, this.state.attachment)} className="btn btn-sm btn-default mr10">插入</button>
            <button onClick={(e) => this.destroyButtonHandler(e, this.state.attachment)} className="btn btn-sm btn-danger">删除</button>

            {!this.props.attachmentPersisted && (
              <input type="hidden" name="post[uploads][]" value={this.state.attachment.signedId} />
            )}
          </div>
        </td>
      </tr>
    }
  }
}

export default class PostFormUploadComponent extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      uploadFileList: [],
      uploadFileListLoading: false,
    }
    this.fileSelector = React.createRef()
    this.fileItemEventEmitter = new EventTarget()
  }

  static get propTypes() {
    return {
      postId: PropTypes.string.isRequired,
      directUploadUrl: PropTypes.string.isRequired,
    }
  }

  componentDidMount() {
    fromEvent(this.fileSelector.current, "change")
      .pipe(
        map((event) => (event.target.files)),
        mergeMap((fileList) => from(fileList)),
        map((file) => ({file: file}))
      )
      .subscribe((fileStruct) => {
        const fileList = [].concat(this.state.uploadFileList, [fileStruct])
        this.setState({uploadFileList: fileList})
      })

    fromEvent(this.fileItemEventEmitter, "FileDestroyed")
      .pipe(
        map((event) => event.attachment),
        concatMap((attachment) => {
          const queries = {}
          const headers = {
            'X-CSRF-Param': $('meta[name="csrf-param"]').attr('content'),
            'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content'),
          }

          if (this.props.postId === "") {
            queries.signed_id = attachment.signedId
          }
          else {
            queries.id = attachment.id
          }

          return ajax.delete(`/admins/posts/uploads?${QueryString.stringify(queries)}`, headers).pipe(
            catchError(() => EMPTY),
            concatMap(() => of(attachment))
          )
        })
      )
      .subscribe((attachment) => {
        const fileIndex = this.state.uploadFileList.findIndex((uploadFile) => {
          return uploadFile.attachment && uploadFile.attachment.id === attachment.id
        })
        const uploadFileList = [].concat(this.state.uploadFileList)

        uploadFileList.splice(fileIndex, 1)

        this.setState({uploadFileList: uploadFileList})
      })

    if (this.props.postId !== "") {
      const uploadsIndexPath = `/admins/posts/${this.props.postId}/uploads`

      ajax.getJSON(uploadsIndexPath, ajaxGetJSONHeader)
        .pipe(
          mergeMap((fileList) => from(fileList)),
          map((attachment) => {
            return {
              attachment: {
                id: attachment.id,
                byteSize: attachment.byte_size,
                filename: attachment.filename,
                isImage: attachment.is_image,
                signedId: attachment.signed_id,
                blobPath: attachment.blob_path,
              },
              attachmentPersisted: true,
            }
          })
        )
        .subscribe((fileStruct) => {
          const fileList = [].concat(this.state.uploadFileList, [fileStruct])
          this.setState({uploadFileList: fileList})
      })
    }
  }

  render() {
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
      {this.state.uploadFileListLoading && (
        <tr>
          <td colSpan="4" className="text-center">正在加载</td>
        </tr>
      )}

      {(!this.state.uploadFileListLoading && this.state.uploadFileList.length === 0) && (
        <tr>
          <td colSpan="4" className="text-center">暂无文件</td>
        </tr>
      )}

      {this.state.uploadFileList.length > 0 && this.state.uploadFileList.map((fileStruct, index) => (
        <UploadFile key={index}
                    index={index + 1}
                    directUploadUrl={this.props.directUploadUrl}
                    fileItemEventEmitter={this.fileItemEventEmitter}

                    file={fileStruct.file}
                    attachment={fileStruct.attachment}
                    attachmentPersisted={fileStruct.attachmentPersisted} />
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
