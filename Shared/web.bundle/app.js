var connection = new WebSocket('%%WEBSOCKET_URL%%');

var openedConnections = 0;

connection.onopen = function() {
  openedConnections++;
  $('#status-container')
    .removeClass('error disconnected')
    .addClass('connected');
};

connection.onclose = function() {
  if (!--openedConnections) {
    $('#status-container')
      .removeClass('error connected')
      .addClass('disconnected');
  }
};

connection.onerror = function (error) {
  console.log('WebSocket Error ' + error);

  $('#status-container')
    .removeClass('connected disconnected')
    .addClass('error');
};

connection.onmessage = function (msg) {
  var obj = JSON.parse(msg.data);
  console.log('Server: ' + msg.data);
};

function sendMessage(obj) {
  var json = JSON.stringify(obj);
  connection.send(json);
}

$(function() {
  var timeoutHandle = null;

  function sendText() {
    var text = $('#content-editable').text();
    send({type: 'text', content: text});

    $('#content-editable').html('&nbsp;');
  };

  $('#content-editable').on('keyup', function(e) {
    if (timeoutHandle)
      clearTimeout(timeoutHandle);

    timeoutHandle = setTimeout(sendText, 750);

    console.log(e.keyCode)
    return false;
  });

  $('#edit-container').on('click', function() {
    $('#content-editable').focus()
  })
});

