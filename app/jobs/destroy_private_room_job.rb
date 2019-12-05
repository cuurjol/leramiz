class DestroyPrivateRoomJob < ApplicationJob
  queue_as :default

  def perform(room)
    users = room.users.to_a
    message = "Expiration time for Room ##{room.id} is over"
    users.each { |user| Rails.cache.write("message_for_user:#{user.id}", message) }

    room.update(status: 'deleted')
    ActionCable.server.broadcast('room_management_channel', room: room.as_json(only: %i[id is_private token status]))

    sleep(1.5) # Задержка на удаление комнаты со всеми сообщениями после редиректа на главную страницу
    room.destroy
  end
end
