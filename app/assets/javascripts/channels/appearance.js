jQuery(document).on('turbolinks:load', function() {
  App.appearance = App.cable.subscriptions.create("AppearanceChannel", {
    connected: function() {},

    disconnected: function() {},

    received: function(data) {
      $('#all-online-users').text(`Online: ${data["users"].map(user => user.nickname).join(', ')}`)
    }
  });
});
