class DestroyPrivateRoomJob < ApplicationJob
  queue_as :default

  def perform(room)
    room.destroy
    ActionCable.server.broadcast('room_management_channel', room: room.as_json(only: %i[id is_private token]),
                                                            status: 'destroyed')

    room_users_list = { room_id: room.id, users: room.users.uniq.as_json(only: :nickname) }
    ActionCable.server.broadcast('room_users_list_channel', room_users_list: room_users_list)
  end
end
