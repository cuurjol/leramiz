App.appearance_online_user = App.cable.subscriptions.create("AppearanceOnlineUserChannel", {
  connected: function() {},

  disconnected: function() {},

  received: function(data) {
    $('#all-online-users').text(`Online: ${data["users"].map(user => user.nickname).join(', ')}`)
  }
});