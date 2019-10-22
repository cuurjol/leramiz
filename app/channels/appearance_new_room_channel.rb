class AppearanceNewRoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'appearance_new_room_channel'
  end
end
