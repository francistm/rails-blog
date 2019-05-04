import React, { PureComponent } from 'react'
import PropTypes from 'prop-types'
import { DirectUpload } from 'activestorage'
import { fromEvent } from 'rxjs'
import { map } from 'rxjs/operators'
import {
  createFileDestroyedEvent,
  createFileInsertEvent,
  createFileUploadFailedEvent,
  createFileUploadSucceedEvent
} from './events'

export default class UploadFile extends PureComponent {
  constructor (props) {
    super(props)

    this.state = {
      uploadProgress: 0,
    }

    this.insertButtonHandler = this.insertButtonHandler.bind(this)
  }

  static get propTypes () {
    return {
      uniqueId: PropTypes.string.isRequired,
      directUploadUrl: PropTypes.string.isRequired,
      fileItemEventEmitter: PropTypes.instanceOf(EventTarget),

      file: PropTypes.instanceOf(File),
      postUpload: PropTypes.shape({
        byteSize: PropTypes.number.isRequired,
        filename: PropTypes.string.isRequired,
        isImage: PropTypes.bool.isRequired,
        blobPath: PropTypes.string.isRequired,
      }),
    }
  }

  static formatFileSize (size) {
    const unit = ['B', 'KB', 'MB', 'GB']
    const base = Math.floor(Math.log10(size))
    const unitBase = Math.round(Math.log(base) / Math.log(3))

    return [(size / Math.pow(1000, unitBase)).toFixed(2), unit[unitBase]].join(' ')
  }

  componentDidMount () {
    const { file, uniqueId, directUploadUrl, fileItemEventEmitter } = this.props;

    if (file) {
      const directUpload = new DirectUpload(file, directUploadUrl, this)

      directUpload.create((err, blob) => {
        if (err) {
          fileItemEventEmitter.dispatchEvent(createFileUploadFailedEvent(uniqueId, file, err))
        } else {
          fileItemEventEmitter.dispatchEvent(createFileUploadSucceedEvent(uniqueId, file, blob.signed_id))
        }
      })
    }
  }

  insertButtonHandler (event, upload) {
    const { uniqueId, fileItemEventEmitter } = this.props;

    fileItemEventEmitter.dispatchEvent(createFileInsertEvent(uniqueId, upload))

    event.preventDefault()
  }

  destroyButtonHandler (event, upload) {
    const { uniqueId, fileItemEventEmitter } = this.props;

    fileItemEventEmitter.dispatchEvent(createFileDestroyedEvent(uniqueId, upload))

    event.preventDefault()
  }

  // Hook for ActionStorage DirectUpload, DO NOT change the method name
  // Upload progress update with event
  directUploadWillStoreFileWithXHR (request) {
    fromEvent(request.upload, 'progress')
      .pipe(map((e) => ({ total: e.total, loaded: e.loaded })))
      .subscribe((progress) => {
        this.setState({ uploadProgress: progress.loaded / progress.total })
      })
  }

  render () {
    const { uploadProgress } = this.state
    const { file, postUpload } = this.props

    const formatFileSize = this.constructor.formatFileSize

    if (file) {
      return <tr>
        <td>PLACEHOLDER</td>
        <td>{file.name}</td>
        <td>{formatFileSize(file.size)}</td>
        <td>
          <div className="progress mb0">
            <div className="progress-bar" style={{ width: uploadProgress * 100 + '%' }}/>
          </div>
        </td>
      </tr>
    } else if (postUpload) {
      return <tr>
        <td>PLACEHOLDER</td>
        <td>{postUpload.filename}</td>
        <td>{formatFileSize(postUpload.byteSize)}</td>
        <td>
          <div>
            <button onClick={(e) => this.insertButtonHandler(e, postUpload)}
                    className="btn btn-sm btn-default mr10">插入
            </button>
            <button onClick={(e) => this.destroyButtonHandler(e, postUpload)}
                    className="btn btn-sm btn-danger">删除
            </button>

            {postUpload.className === 'ActiveStorage::Blob' && (
              <input type="hidden" name="post[uploads][]" value={postUpload.signedId}/>
            )}
          </div>
        </td>
      </tr>
    } else {
      return <tr>
        <td colSpan="4" className="text-center">出现错误</td>
      </tr>
    }
  }
}