App.room_users_list = App.cable.subscriptions.create("RoomUsersListChannel", {
  connected: function() {},

  disconnected: function() {},

  received: function(data) {
    let users = data['room_users_list']['users'].map(user => user.nickname).join(', ');
    let room_users_list = $(`.room-users-list[data-room-id='${data['room_users_list']['room_id']}']`);

    if (users.length > 0) {
      if (room_users_list.length) {
        room_users_list.text(`Room users: ${users}`);
      } else {
        let html_code = `
        <div class="text-danger room-users-list" data-room-id="${data['room_users_list']['room_id']}">
            Room users: ${users}
         </div>`;

        $(`li[data-room-id='${data['room_users_list']['room_id']}']`).append(html_code);
      }
    } else {
      room_users_list.remove();
    }
  }
});