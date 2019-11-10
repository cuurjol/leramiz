class RoomUsersListChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'room_users_list_channel'
  end
end
