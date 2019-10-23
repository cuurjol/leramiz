// https://decaffeinate-project.org/
// http://js2.coffee/

let createRoomChannel = function(roomId) {
  return App.room = App.cable.subscriptions.create({channel: "RoomChannel", roomId}, {
    connected() {},

    disconnected() {},

    received(data) {
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
  } else if (App.room) {
    // https://stackoverflow.com/questions/39541259/rails-actioncable-turbolinks-chat-issue-posting-duplicate-messages
    // https://stackoverflow.com/questions/40495351/how-to-close-connection-in-action-cable
    // https://stackoverflow.com/questions/39017691/actioncable-unsubscribe-callback-not-working-when-ios-client-send-unsubscribe/44933949
    // App.cable.subscriptions.remove(App.room);
    App.room.unsubscribe();
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
