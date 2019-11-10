class RoomManagementChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'room_management_channel'
  end
end
