App.room_management = App.cable.subscriptions.create("RoomManagementChannel", {
  connected: function() {},

  disconnected: function() {},

  received: function(data) {
    if (data['status'] === 'created') {
      let html_code = `
        <li data-room-id="${data['room']['id']}">
            <b>Room #${data['room']['id']}</b> — <a href="/rooms/${data['room']['token']}">Join</a>
         </li>
         <div class="text-danger room-users-list" data-room-id="${data['room']['id']}"></div>`;

      data['room']['is_private'] ? $('#private-rooms-list').append(html_code) : $('#public-rooms-list').append(html_code);
    } else {
      $(`li[data-room-id='${data['room']['id']}']`).remove();
    }
  }
});