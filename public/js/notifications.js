var Notifications = function(){
  var self = this
  var openStatus = true

  self.onmessage = function(event) {
    var msg = JSON.parse(event.data)
    var evt = new CustomEvent('newNotification', { detail: msg })
    window.dispatchEvent(evt);
  }

  /* ----------------------------------------- */
  self.connect = function() {
    self.server = new EventSource('/live/notifications/connect');
    self.server.onmessage = self.onmessage
  }

  self.push = function(msg) {
    $.post('/live/notifications/push', msg, 'json')
  }

  self.close = function() {
    openStatus = false
    self.server.close()
  }

  self.connect();
};
