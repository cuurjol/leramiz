App.room_management = App.cable.subscriptions.create("RoomManagementChannel", {
  connected: function() {},

  disconnected: function() {},

  received: function(data) {
    let private_rooms_list = $('#private-rooms-list');
    let public_rooms_list = $('#public-rooms-list');
    let html_code;

    if (data['room']['is_private'] && private_rooms_list.length === 0) {
      html_code = `
        <div class="col-md-6">
            <h4>Private:</h4>
            <ul class="list-unstyled" id="private-rooms-list"></ul>
        </div>`;
      $('div.row.mt-4').append(html_code);
      private_rooms_list = $('#private-rooms-list');
    }

    if (!data['room']['is_private'] && public_rooms_list.length === 0) {
      html_code = `
        <div class="col-md-6">
            <h4>Public:</h4>
            <ul class="list-unstyled" id="public-rooms-list"></ul>
        </div>`;
      $('div.row.mt-4').append(html_code);
      public_rooms_list = $('#public-rooms-list');
    }

    if (data['status'] === 'created') {
      html_code = `
        <li data-room-id="${data['room']['id']}">
            <b>Room #${data['room']['id']}</b> — <a href="/rooms/${data['room']['token']}">Join</a>
         </li>
         <div class="text-danger room-users-list" data-room-id="${data['room']['id']}"></div>`;

      data['room']['is_private'] ? private_rooms_list.append(html_code) : public_rooms_list.append(html_code);
    } else {
      $(`li[data-room-id='${data['room']['id']}']`).remove();
      $(`.room-users-list[data-room-id='${data['room']['id']}']`).remove();

      if (private_rooms_list.children().length === 0) {
        private_rooms_list.closest('.col-md-6').find('h4').remove();
      }
    }
  }
});