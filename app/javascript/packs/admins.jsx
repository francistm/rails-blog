import {fromEvent} from "rxjs"
import {filter, map, take} from "rxjs/operators"
import React from "react"
import {render, unmountComponentAtNode} from "react-dom"

import PostFormUploadComponent from "./components/post_form_upload"

fromEvent(document, "turbolinks:load")
  .pipe(
    map(() => document.getElementById("post-form-upload-component")),
    filter((dom) => dom !== null)
  )
  .subscribe(function (mountDOM) {
    const postIdInputNode = document.getElementById("post_id")
    const directUploadFileInputNode = document.getElementById("post_uploads")

    const component = <PostFormUploadComponent
      postId={postIdInputNode.value}
      directUploadUrl={directUploadFileInputNode.getAttribute("data-direct-upload-url")}
    />

    render(component, mountDOM, function () {
      fromEvent(document, "turbolinks:before-visit")
        .pipe(take(1))
        .subscribe(() => {
          unmountComponentAtNode(mountDOM)
        })
    })
  })
