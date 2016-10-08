//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require nprogress
//= require nprogress-turbolinks
//= require underscore.min
//= require jquery.fileupload
//= require jquery.plugins

class App
  render: ->
    _.each @pages, (page, index, pages) ->
      page.render()
  unload: ->
    _.each @pages, (page, index, pages) ->
      page.unload()

  addPage: (page) ->
    @pages.push page

  constructor: ->
    @pages = []

class Page
  render: ->
    this.renderPage() if $(@selector).length > 0
  unload: ->
    this.unloadPage() if @rendered

  renderPage: ->
    @rendered = true
  unloadPage: ->
    @rendered = false

  constructor: (@selector) ->
    @rendered = false

class AdminPostPage extends Page
  renderPage: ->
    super
    $("#file-add-btn").fileupload({
      type: 'POST'
      formData: {}
      url: '/admins/uploads.js'
      paramName: 'upload[file]'
      change: (e, data) ->
        $("#file-add-btn").parent().addClass('disabled')
        $("#file-add-btn").siblings('.btn-text').html('上传中')
      error: (xhr, status, error) ->
        alert "文件上传失败，请重试"
        $("#file-add-btn").parent().removeClass('disabled')
        $("#file-add-btn").siblings('.btn-text').html('选择文件')
      success: (result, status, xhr) ->
        $("#file-add-btn").parent().removeClass('disabled')
        $("#file-add-btn").siblings('.btn-text').html('选择文件')
    })

    $(@selector).on 'click', '[data-markdown-url]', (e) ->
      tpl = _.template('<<%= url %>>')
      url = $(e.target).attr 'data-url'

      $("#post_content").insertAtCaret tpl(url: url)

    $(@selector).on 'click', '[data-markdown-image]', (e) ->
      tpl = _.template('![](<%= url %>)')
      url = $(e.target).attr 'data-url'

      $("#post_content").insertAtCaret tpl(url: url)

  unloadPage: ->
    super
    $("#file-add-btn").fileupload('destroy')
    $(@selector).off 'click', '[data-markdown-url]'
    $(@selector).off 'click', '[data-markdown-image]'


app = new App()
app.addPage new AdminPostPage('[data-admin-post-form]')

document.addEventListener('turbolinks:load', () =>
  app.render()
)

document.addEventListener('turbolinks:before-visit', () =>
  app.unload()
)