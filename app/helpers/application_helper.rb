module ApplicationHelper
  def online_users
    "Online: #{User.online.map(&:nickname).join(', ')}"
  end

  def room_users(room)
    "Room users: #{room.users.map(&:nickname).join(', ')}" if room.users.present?
  end
end
