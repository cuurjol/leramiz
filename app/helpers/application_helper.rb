module ApplicationHelper
  def online_users
    "Online: #{User.online.map(&:nickname).join(', ')}"
  end

  def room_item_list(room)
    link = link_to('Join', room, data: { turbolinks: false })
    if room.users.present?
      room_users = content_tag(:div, room_users(room), class: 'text-danger room-users-list',
                                                       data: { 'room-id': room.id })
    end

    <<~HTML.html_safe
      <b>Room ##{room.id}</b> — #{link}
      #{room_users}
    HTML
  end

  def room_users(room)
    "Room users: #{room.users.uniq.map(&:nickname).join(', ')}"
  end

  def private_room?(room)
    room.try(:persisted?) && room.is_private?
  end

  # Метод вычисления оставшегося времени истечения приватной комнаты:
  # 1) room.expiration * 60 - время истечения приватной комнаты в секундах
  # 2) (Time.now - room.created_at) - разность между текущей датой и датой создании приватной комнаты в секундах
  # 3) 1.5.seconds - время задержки для выполнения фоновой задачи по удалению всей информации о приватной комнате
  def remaining_expiration_time(room)
    room.expiration * 60 - (Time.now - room.created_at) + 1.5.seconds
  end
end
