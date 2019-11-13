module ApplicationHelper
  def online_users
    "Online: #{User.online.map(&:nickname).join(', ')}"
  end

  def room_users(room)
    "Room users: #{room.users.uniq.map(&:nickname).join(', ')}"
  end

  def show_errors_for(object)
    return if object.errors.blank?

    content_tag(:div, class: 'card border-danger mb-4') do
      concat(content_tag(:div, class: 'card-header bg-danger text-white') do
        concat "#{pluralize(object.errors.count, 'error')} prohibited this #{object.class.name.downcase} " \
                 'from being saved:'
      end)
      concat(content_tag(:div, class: 'card-body') do
        concat(content_tag(:ul, class: 'mb-0') do
          object.errors.full_messages.each do |msg|
            concat content_tag(:li, msg)
          end
        end)
      end)
    end
  end

  def private_room?(room)
    room.try(:persisted?) && room.is_private?
  end

  # Метод вычисления оставшегося времени истечения приватной комнаты:
  # 1) room.expiration * 60 - время истечения приватной комнаты в секундах
  # 2) (Time.now - room.created_at) - разность между текущей датой и датой создании приватной комнаты в секундах
  def remaining_expiration_time(room)
    room.expiration * 60 - (Time.now - room.created_at)
  end
end
