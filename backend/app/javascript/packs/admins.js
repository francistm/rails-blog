import React from 'react'
import { fromEvent } from 'rxjs'
import { filter, map, take } from 'rxjs/operators'
import { render, unmountComponentAtNode } from 'react-dom'
import { PostFormUploader } from './components'

const turbolinksChanged = fromEvent(document, 'turbolinks:load')

turbolinksChanged
  .pipe(
    map(() => document.getElementById('post-form-upload-component')),
    filter((dom) => dom !== null)
  )
  .subscribe(function (mountDOM) {
    const postIdInputNode = document.getElementById('post_id')
    const postContentNode = document.getElementById('post_content')
    const directUploadFileInputNode = document.getElementById('post_uploads')

    const component = (
      <PostFormUploader
        postId={postIdInputNode.value}
        postContentNode={postContentNode}
        directUploadUrl={directUploadFileInputNode.getAttribute('data-direct-upload-url')}
      />
    )

    render(component, mountDOM, function () {
      fromEvent(document, 'turbolinks:before-visit')
        .pipe(take(1))
        .subscribe(() => {
          unmountComponentAtNode(mountDOM)
        })
    })
  })
