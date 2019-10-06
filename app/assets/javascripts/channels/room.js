// https://decaffeinate-project.org/
// http://js2.coffee/

let createRoomChannel = function(roomId) {
  return App.room = App.cable.subscriptions.create({channel: "RoomChannel", roomId}, {
    connected() {
      return console.log('Connected to RoomChannel');
    },

    disconnected() {
      return console.log('Disconnected from RoomChannel');
    },

    received(data) {
      console.log('Received message: ' + data['message']);
      $('#messages').append(data['message']);

      return scroll_bottom();
    },

    speak(message) {
      return this.perform('speak', {message});
    }
  });
};

let scroll_bottom = function () {
  messages.scrollTop = messages.scrollHeight;
};

jQuery(document).on('turbolinks:load', function() {
  const messages = $('#messages');

  if (messages.length > 0) {
    createRoomChannel(messages.data('room-id'));
  }

  return $(document).on('keypress', '#message_body', function(event) {
    const message = event.target.value;
    if (event.keyCode === 13) {
      if (message.trim() !== '') {
        App.room.speak(message);
        event.target.value = "";
        return event.preventDefault();
      } else {
        return event.preventDefault();
      }
    }
  });
});
