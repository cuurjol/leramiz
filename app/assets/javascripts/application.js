//= require rails-ujs
//= require turbolinks
//= require jquery
//= require bootstrap
//= require local-time
//= require_tree .

$(document).on('turbolinks:load', function() {
  $('#change-password-button').click(function(){
    $('.show-form, .hide-form').slideToggle(400, function () {
      let btn = $('#change-password-button');
      btn.text() === 'Change password' ? btn.text('Hide password form') : btn.text('Change password');
    });

    return false;
  });

  let public_radio_button = $('#room_is_private_false');
  let private_radio_button = $('#room_is_private_true');
  let room_expiration = $('#room_expiration');
  let room_password = $('#room_password');

  if (private_radio_button.is(':checked')) {
    room_expiration.prop('disabled', false);
    room_password.prop('disabled', false);
  }

  private_radio_button.click(function() {
    room_expiration.prop('disabled', false);
    room_password.prop('disabled', false);
  });

  public_radio_button.click(function() {
    room_expiration.prop('disabled', true).val('');
    room_password.prop('disabled', true).val('');
  });

  room_expiration.on('keypress cut copy paste', function(event){
    switch (event.type) {
      case 'keypress':
        if(event.charCode < 48 || event.charCode > 57 || event.charCode === 48 && this.selectionStart === 0){
          event.preventDefault();
        }
        break;
      case 'cut':
      case 'copy':
      case 'paste':
        event.preventDefault();
        break;
    }
  });
});
