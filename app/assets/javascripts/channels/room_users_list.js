let createRoomUsersListChannel = function(roomIds) {
  return App.room_users_list = App.cable.subscriptions.create({ channel: "RoomUsersListChannel", roomIds } , {
    connected: function() {},

    disconnected: function() {},

    received: function(data) {
      $.each(data["room_users_list"], function (index, value) {
        let users = value["users"].map(user => user.nickname).join(', ');
        $(`.room-users-list[data-room-id='${value["room_id"]}']`).text(users ? `Room users: ${users}` : '');
      });
    }
  });
};

jQuery(document).on('turbolinks:load', function() {
  const room_users_list = $('.room-users-list');

  if (!App.room_users_list) {
    if (room_users_list.length > 0) {
      let room_ids = [];
      $.each(room_users_list, function (index, value) {
        room_ids.push(value.dataset.roomId)
      });
      createRoomUsersListChannel(room_ids);
    } else {
      createRoomUsersListChannel([]);
    }
  }
});