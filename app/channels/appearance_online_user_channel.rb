class AppearanceOnlineUserChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'appearance_online_user_channel'
    broadcast_online_users(true)
  end

  def unsubscribed
    connections_count = ActionCable.server.connections.select { |conn| conn.current_user == current_user }.count
    broadcast_online_users(false) if connections_count.zero?
  end

  private

  def broadcast_online_users(online)
    current_user.update_attribute(:online, online)
    ActionCable.server.broadcast('appearance_online_user_channel', users: User.online.as_json(only: :nickname))
  end
end
