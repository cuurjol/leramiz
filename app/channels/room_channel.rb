class RoomChannel < ApplicationCable::Channel
  def subscribed
    @room = Room.find(params[:roomId])

    stream_from("room_channel_#{@room.id}")

    @room.room_users.create(user: current_user)

    return if @room.room_users.where(user: current_user).count > 1

    broadcast_room_users

    speak('message' => '* * * joined the room * * *')
  end

  def unsubscribed
    # Проверка нужна здесь после того, как выполнится фоновая задача на удаление приватной комнаты
    return if Room.find_by_id(@room).nil?

    @room.reload.room_users.find_by(user: current_user).destroy

    return if @room.room_users.where(user: current_user).count.positive?

    broadcast_room_users

    speak('message' => '* * * left the room * * *')
  end

  def speak(data)
    MessageService.new(body: data['message'], room: @room, user: current_user).perform
  end

  private

  def broadcast_room_users
    room_users_list = { room_id: @room.id, users: @room.users.uniq.as_json(only: :nickname) }
    ActionCable.server.broadcast('room_users_list_channel', room_users_list: room_users_list)
  end
end
