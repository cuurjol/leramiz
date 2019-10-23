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

// https://stackoverflow.com/questions/44433953/jumping-scrollbar-after-auto-expanding-textarea
let resizeTextarea = function(elem) {
  // two additional variables getting the top and left scroll positions.
  let scrollLeft = window.pageXOffset;
  let scrollTop  = window.pageYOffset;

  elem.css('height', 'auto').css('height', elem.prop('scrollHeight'));
  // Applying previous top and left scroll position after textarea resize.
  window.scrollTo(scrollLeft, scrollTop);
};

jQuery(document).on('turbolinks:load', function() {
  const messages = $('#messages');

  $('textarea').on('input', function() {
    resizeTextarea($(this));
  });

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
    let message = event.target.value;

    if ((event.shiftKey || event.ctrlKey) && (event.keyCode === 13 || event.keyCode === 10)) {
      if (message.trim() !== '') {
        let start = this.selectionStart;
        event.target.value = message.substring(0, start) + "\n" + this.value.substring(start);
        resizeTextarea($('textarea'));
        this.selectionStart = this.selectionEnd = start + 1;
        return event.preventDefault();
      } else {
        event.target.value = "";
        return event.preventDefault();
      }
    } else if (event.keyCode === 13) {
      if (message.trim() !== '') {
        App.room.speak(message);
        event.target.value = "";
        resizeTextarea($('textarea'));
        return event.preventDefault();
      } else {
        event.target.value = "";
        return event.preventDefault();
      }
    }
  });
});
