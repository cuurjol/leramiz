class RoomUsersListChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'room_users_list_channel'
  end

  def unsubscribed
    broadcast_room_users
  end

  private

  def broadcast_room_users
    room_users_list = []
    rooms = Room.includes(:users).where(id: params[:roomIds])
    rooms.each { |room| room_users_list << { room_id: room.id, users: room.users.as_json(only: :nickname) } }

    ActionCable.server.broadcast('room_users_list_channel', room_users_list: room_users_list)
  end
end
