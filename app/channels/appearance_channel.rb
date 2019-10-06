class AppearanceChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'appearance_channel'
    broadcast_online_users(true)
  end

  def unsubscribed
    broadcast_online_users(false)
  end

  private

  def broadcast_online_users(online)
    current_user.update_attribute(:online, online)
    ActionCable.server.broadcast('appearance_channel', users: User.online.as_json(only: :nickname))
  end
end
