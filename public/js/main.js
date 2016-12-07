"use strict";

$(function() {
    function search_users(form, callback) {
        var form_data = form.serialize();
        $.ajax({
            type: form.attr('method'),
            url: form.attr('action'),
            data: form_data,
            dataType: 'json',
        }).done(callback);
    }

    $('#user-search').submit(function(event) {
        event.preventDefault()
        search_users($(this), function(data) {
            $('#user-search-result').html("")
            $(data).each(function(index, User) {
                var list_item = $(
                    '<li class="pure-menu-item" />'
                )
                var anchor = $('<a class="pure-menu-link" />')
                anchor.attr('href', "/connect/"+User.id)
                anchor.text(User.username)
                list_item.append(anchor)
                $('#user-search-result').append(list_item);
            })
        })
        return false;
    })

    var notify = new Notifications();

    window.addEventListener('newNotification', function (e) {
      var notification = e.detail

      switch (notification.type) {
        case "chat-message":
          console.log("You have new Message")
          break;
        default:

      }

    });
})
