App.room_management = App.cable.subscriptions.create("RoomManagementChannel", {
  connected: function() {},

  disconnected: function() {},

  received: function(data) {
    let is_private = data['room']['is_private'];
    let rooms_list = is_private ? $('#private-rooms-list') : $('#public-rooms-list');
    let html_code;

    if (rooms_list.length === 0) {
      html_code = `
        <div class="col-md-6">
            <h4>${is_private ? 'Private:' : 'Public:'}</h4>
            <ul class="list-unstyled" id=${is_private ? "private-rooms-list" : "public-rooms-list"}></ul>
        </div>`;

      $('div.row.mt-4').append(html_code);
      rooms_list = $(rooms_list.selector);
    }

    if (data['room']['status'] === 'created') {
      html_code = `
        <li data-room-id="${data['room']['id']}">
            <b>Room #${data['room']['id']}</b> — <a href="/rooms/${data['room']['token']}" data-turbolinks="false">Join</a>
            <div class="text-danger room-users-list" data-room-id="${data['room']['id']}"></div>
         </li>`;

      rooms_list.append(html_code);
    } else {
      $(`li[data-room-id='${data['room']['id']}']`).remove();

      if (rooms_list.children().length === 0) {
        rooms_list.closest('.col-md-6').remove();
      }
    }
  }
});