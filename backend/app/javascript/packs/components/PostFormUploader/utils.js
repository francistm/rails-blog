export function insertIntoInputCaret(inputDOM, getInsertContent) {
  const domContent = inputDOM.value;
  const selectionStartPos = inputDOM.selectionStart;
  const selectionEndPos = inputDOM.selectionEnd;

  // No selection, insert at caret
  if (selectionStartPos === selectionEndPos) {
    const contentToAppend = getInsertContent(null);

    inputDOM.value = inputDOM.value + contentToAppend;
  }
  // Replace selection with Markdown link syntax
  else {
    const contentAfter = domContent.substr(selectionEndPos);
    const contentBefore = domContent.substr(0, selectionStartPos);
    const selectedContent = domContent.substr(selectionStartPos, selectionEndPos - selectionStartPos);
    const selectedReplacement = getInsertContent(selectedContent);

    inputDOM.value = [contentBefore, selectedReplacement, contentAfter].join('');
  }

  inputDOM.focus();
}