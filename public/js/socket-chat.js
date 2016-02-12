var SocketChat = function(url, post_message){
  var self = this
  var openStatus = true

  self.onmessage = function(event) {
    var msg = JSON.parse(event.data)
    post_message(msg)
  }

  self.onopen = function() {
    console.log('SocketChat is open')
  }

  self.onclose = function(event) {
    console.log("WebSocket CLOSING", url)
    if(openStatus) self.connect()
  }

  /* ----------------------------------------- */
  self.connect = function() {
    console.log("WebSocket CONNECTING", url)
    self.server = new WebSocket(url);
    self.server.onclose = self.onopen
    self.server.onclose = self.onclose
    self.server.onmessage = self.onmessage
  }

  self.send = function(msg) {
    self.server.send(msg)
  }

  self.close = function() {
    openStatus = false
    self.server.close()
  }

  self.connect();
};
