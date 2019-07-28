export const FILE_INSERT_EVENT_TYPE = 'FileInsert';
export const FILE_DESTROYED_EVENT_TYPE = 'FileDestroyed';
export const FILE_UPLOAD_FAILED_EVENT_TYPE = 'FileUploadFailed';
export const FILE_UPLOAD_SUCCEED_EVENT_TYPE = 'FileUploadSucceed';

export function createFileInsertEvent (uniqueId, postUpload) {
  return new CustomEvent(FILE_INSERT_EVENT_TYPE, {
    detail: {
      uniqueId: uniqueId,
      postUpload: postUpload,
    }
  })
}

export function createFileDestroyedEvent (uniqueId, postUpload) {
  return new CustomEvent(FILE_DESTROYED_EVENT_TYPE, {
    detail: {
      uniqueId: uniqueId,
      postUpload: postUpload,
    }
  })
}

export function createFileUploadFailedEvent (uniqueId, uploadFile, originError) {
  return new CustomEvent(FILE_UPLOAD_FAILED_EVENT_TYPE, {
    detail: {
      uniqueId: uniqueId,
      uploadFile: uploadFile,
      originError: originError,
    }
  })
}

export function createFileUploadSucceedEvent (uniqueId, uploadFile, signedId) {
  return new CustomEvent(FILE_UPLOAD_SUCCEED_EVENT_TYPE, {
    detail: {
      uniqueId: uniqueId,
      signedId: signedId,
      uploadFile: uploadFile,
    }
  })
}
