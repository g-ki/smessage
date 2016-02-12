"use strict";

function message(msg) {
  var message_box = '<div class="message"><h5 class="author"></h5>'
  message_box += '<div class="content-wrap clearfix"><span class="content">'
  message_box += '</span></div></div>'
  message_box = $(message_box)

  message_box.find('.author').text(msg.author)
  var content = message_box.find("span.content")
  content.text(msg.message.content)
  if(msg.right) {
    message_box.find('.author').text('')
    content.addClass("right")
  }

  $("#message-log").append(message_box);
  $("#message-log").scrollTop($("#message-log")[0].scrollHeight)
}

$(function() {

  $("#message-log").scrollTop($("#message-log")[0].scrollHeight)

  var url = location.href.replace("chat", "live/chat").replace("http", "ws")
  var chat = new SocketChat(url, function(data) {
    message(data)
    var message_is_viewed = {message_id: data.message.id, type: 'view' }
    chat.send(JSON.stringify(message_is_viewed))
  });

  $('#input-message').keypress(function(event){
    if (event.keyCode == '13') {
      var message = {message: $(this).val(), type: 'message' }
      chat.send(JSON.stringify(message))
      $(this).val('')
      return false;
    }
  })

});
