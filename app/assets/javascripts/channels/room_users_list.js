App.room_users_list = App.cable.subscriptions.create("RoomUsersListChannel", {
  connected: function() {},

  disconnected: function() {},

  received: function(data) {
    let users = data["room_users_list"]["users"].map(user => user.nickname).join(', ');
    $(`.room-users-list[data-room-id='${data["room_users_list"]["room_id"]}']`).text(users ? `Room users: ${users}` : '');
  }
});