module ApplicationHelper
  def online_users
    User.online.map(&:nickname).join(', ')
  end
end
