do ($) ->
  $.fn.insertAtCaret = (value) ->
    this.each (i) ->
      if document.selection
        this.focus()
        sel = document.selection.createRange()
        sel.text = value
        this.focus()

      else if this.selectionStart || this.selectionStart == 0
        endPos = this.selectionEnd
        startPos = this.selectionStart
        scrollTop = this.scrollTop

        this.value = this.value.substring(0, startPos) + value + 
                     this.value.substring(endPos, this.value.length)

        this.focus()
        this.selectionStart = startPos + value.length
        this.selectionEnd = startPos + value.length
        this.scrollTop = scrollTop

      else
        this.value += value
        this.focus
