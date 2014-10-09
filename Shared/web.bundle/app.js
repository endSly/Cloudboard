$.extend($.easing, {
  easeOutQuad: function (x, t, b, c, d) {
    return -c *(t/=d)*(t-2) + b;
  }
});

var connection = new WebSocket('%%WEBSOCKET_URL%%')

connection.onopen = function() {
    //connection.send(JSON.stringify({}))
};

connection.onerror = function (error) {
  console.log('WebSocket Error ' + error);
};

connection.onmessage = function (msg) {
  console.log('Server: ' + msg.data);
};

$(function() {
  var timeoutHandle = null;

  function fadeOldText() {
    var oldContent = $('#editable-p').html();
    var text = $('#editable-p').text();
    connection.send(JSON.stringify({type: 'text', content: text}));

    var oldSpan = $('<span class="old-p">').html(oldContent);

    $('#edit-paragraph').prepend(oldSpan);
    $('#editable-p').html('&nbsp;');

    oldSpan.animate({
      bottom: 160,
      opacity: 0
    }, 500, 'easeOutQuad', function() {
      oldSpan.remove();

    });
  };

  $('#editable-p').on('keyup', function(e) {
    if (timeoutHandle)
      clearTimeout(timeoutHandle);

    timeoutHandle = setTimeout(fadeOldText, 750);

    console.log(e.keyCode)
    return false;
  });

  $('#edit-container').on('click', function() {
    $('#editable-p').focus()
  })
});

