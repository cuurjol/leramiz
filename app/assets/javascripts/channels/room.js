// https://decaffeinate-project.org/
// http://js2.coffee/

jQuery(document).on('turbolinks:load', function() {
  const messages = $('#messages');

  if (messages.length > 0) {
    createRoomChannel(messages.data('room-id'));
  }

  return $(document).on('keypress', '#message_body', function(event) {
    const message = event.target.value;
    if ((event.keyCode === 13) && (message !== '')) {
      App.room.speak(message);
      event.target.value = "";
      return event.preventDefault();
    }
  });
});

var createRoomChannel = function(roomId) {
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

      return $(messages).animate({scrollTop: 20000000}, "slow");
    },

    speak(message) {
      return this.perform('speak', {message});
    }
  });
};
