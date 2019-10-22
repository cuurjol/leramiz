App.appearance_new_room = App.cable.subscriptions.create("AppearanceNewRoomChannel", {
  connected: function() {},

  disconnected: function() {},

  received: function(data) {
    $('#rooms-list').append(data['room']);
  }
});