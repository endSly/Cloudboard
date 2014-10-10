var connection;

function createConnection() {
  connection = new WebSocket('%%WEBSOCKET_URL%%');

  connection.onopen = function() {
    $('#status-container')
      .removeClass('error disconnected')
      .addClass('connected');
  };

  connection.onclose = function() {
    $('#status-container')
      .removeClass('error connected')
      .addClass('disconnected');

    // Try to reconnect
    connecttion = null;
    setTimeout(createConnection, 1000);
  };

  connection.onerror = function (error) {
    console.log('WebSocket Error ' + error);
    $('#status-container')
      .removeClass('connected disconnected')
      .addClass('error');
  };

  connection.onmessage = function (msg) {
    var obj = JSON.parse(msg.data);

    if (obj.type == "content-around") {
      $('#content-before').text(obj.before);
      $('#content-after').text(obj.after);
    }
  };
}

function getCaretCharacterOffsetWithin(element) {
  var caretOffset = 0;
  var doc = element.ownerDocument || element.document;
  var win = doc.defaultView || doc.parentWindow;
  var sel;
  if (typeof win.getSelection != "undefined") {
    sel = win.getSelection();
    if (sel.rangeCount > 0) {
      var range = win.getSelection().getRangeAt(0);
      var preCaretRange = range.cloneRange();
      preCaretRange.selectNodeContents(element);
      preCaretRange.setEnd(range.endContainer, range.endOffset);
      caretOffset = preCaretRange.toString().length;
    }
  } else if ((sel = doc.selection) && sel.type != "Control") {
    var textRange = sel.createRange();
    var preCaretTextRange = doc.body.createTextRange();
    preCaretTextRange.moveToElementText(element);
    preCaretTextRange.setEndPoint("EndToEnd", textRange);
    caretOffset = preCaretTextRange.text.length;
  }
  return caretOffset;
}

function sendMessage(obj) {
  var json = JSON.stringify(obj);
  if (connection) {
    connection.send(json);
  }
}

function sendText() {
  var text = $('#content-editable').text();
  sendMessage({type: 'text', content: text});
  $('#content-editable').html('');
}

$(function() {
  createConnection();

  var timeoutHandle = null;
  var lastCursorOffset = 0;

  $('#content-editable').on('keyup', function(e) {
    if (timeoutHandle)
      clearTimeout(timeoutHandle);

    timeoutHandle = setTimeout(sendText, 750);

    var cursorOffset = getCaretCharacterOffsetWithin(document.getElementById('content-editable'));

    // Send especial characters
    switch (e.keyCode) {
    case 13: // Return
      sendMessage({type: 'text', content: "\n"});
      break;
    case 37: // Left
      if (lastCursorOffset == cursorOffset) {
        sendMessage({type: 'movement', offset: -1});
      }
      break;
    case 39: // Right
      if (lastCursorOffset == cursorOffset) {
        sendMessage({type: 'movement', offset: +1});
      }
      break;
    case 8: // Delete
      if (lastCursorOffset == cursorOffset) {
        sendMessage({type: 'backward'});
      }
      break;
    }

    lastCursorOffset = cursorOffset;

    return false;
  });

  $('#edit-container').on('click', function() {
    $('#content-editable').focus()
  })
});

