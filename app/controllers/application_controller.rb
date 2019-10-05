class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find_by_id(cookies.signed[:user_id])

    if @current_user.nil?
      @current_user = User.create
      cookies.signed[:user_id] = @current_user.id
    end

    @current_user
  end
end
