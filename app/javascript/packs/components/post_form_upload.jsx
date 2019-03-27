import React from "react"
import {from, fromEvent} from "rxjs"
import {map, mergeMap} from "rxjs/operators"
import {ajax} from "rxjs/ajax"
import PropTypes from "prop-types"
import {DirectUpload} from "activestorage"

const UPLOAD_STATUS_PENDING = 'PENDING'
const UPLOAD_STATUS_UPLOADED = 'UPLOADED'

class UploadFile extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      uploadProgress: 0,
      uploadStatus: props.uploadStatus,
      uploadBlogSignedId: "",
    }
  }

  static get propTypes() {
    return {
      index: PropTypes.number.isRequired,
      uploadStatus: PropTypes.oneOf([UPLOAD_STATUS_PENDING, UPLOAD_STATUS_UPLOADED]).isRequired,
      directUploadUrl: PropTypes.string.isRequired,
      file: PropTypes.oneOfType([
        PropTypes.instanceOf(File),
        PropTypes.shape({
          size: PropTypes.number.isRequired,
          name: PropTypes.string.isRequired,
          url: PropTypes.string.isRequired,
          content_type: PropTypes.string.isRequired,
        }),
      ]).isRequired,
    }
  }

  static formatFileSize(size) {
    const unit = ['B', 'KB', 'MB', 'GB']
    const base = Math.floor(Math.log10(size))
    const unitBase = Math.round(Math.log(base) / Math.log(3))

    return [(size / Math.pow(1000, unitBase)).toFixed(2), unit[unitBase]].join(' ')
  }

  componentDidMount() {
    if (this.state.uploadStatus === UPLOAD_STATUS_PENDING) {
      const directUpload = new DirectUpload(this.props.file, this.props.directUploadUrl, this)

      directUpload.create((err, blob) => {
        if (err) {
          throw err
        }

        this.setState({
          uploadBlogSignedId: blob.signed_id,
          uploadStatus: UPLOAD_STATUS_UPLOADED,
        })
      })
    }
  }

  // Hook for ActionStorage DirectUpload
  // Upload progress update with event
  directUploadWillStoreFileWithXHR(request) {
    fromEvent(request.upload, "progress")
      .pipe(map((e) => ({total: e.total, loaded: e.loaded})))
      .subscribe((progress) => {
        this.setState({uploadProgress: progress.loaded / progress.total})
      })
  }

  render() {
    return <tr>
      <td>{this.props.index}</td>
      <td>{this.props.file.name}</td>
      <td>{this.constructor.formatFileSize(this.props.file.size)}</td>
      <td>
        {this.state.uploadStatus === UPLOAD_STATUS_PENDING && (
          <div className="progress mb0">
            <div className="progress-bar" style={{width: this.state.uploadProgress * 100 + '%'}}/>
          </div>
        )}

        {this.state.uploadStatus === UPLOAD_STATUS_UPLOADED && (
          <div>
            <button className="btn btn-danger">删除</button>
            <input type="hidden" name="post[uploads][]" value={this.state.uploadBlogSignedId}/>
          </div>
        )}
      </td>
    </tr>
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
        mergeMap((fileList) => from(fileList))
      )
      .subscribe((file) => {
        const fileList = [].concat(this.state.uploadFileList, [{
          file: file,
          uploadStatus: UPLOAD_STATUS_PENDING,
        }])

        this.setState({uploadFileList: fileList})
      })

    if (this.props.postId.length > 0) {
      const headers = {
        'Content-Type': 'application/json; charset=utf8',
      }
      const uploadsIndexPath = `/admins/posts/${this.props.postId}/uploads`

      ajax.getJSON(uploadsIndexPath, headers)
        .pipe(
          mergeMap((fileList) => from(fileList)),
          map((remoteFile) => ({
            file: remoteFile,
            uploadStatus: UPLOAD_STATUS_UPLOADED,
          }))
        )
        .subscribe((remoteFile) => {
          const fileList = [].concat(this.state.uploadFileList, [remoteFile])
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

      {this.state.uploadFileList.length > 0 && this.state.uploadFileList.map((uploadFile, index) => (
        <UploadFile key={index}
                    index={index + 1}
                    file={uploadFile.file}
                    uploadStatus={uploadFile.uploadStatus}
                    directUploadUrl={this.props.directUploadUrl}/>
      ))}
      </tbody>

      <tfoot>
      <tr>
        <td className="text-right" colSpan="4">
          <div className="btn btn-primary file-hidden-input-container">
            <input ref={this.fileSelector} type="file" multiple className="file-hidden-input"/>
            <span className="btn-text">选择文件</span>
          </div>
        </td>
      </tr>
      </tfoot>
    </table>
  }
}
