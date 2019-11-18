class RoomsController < ApplicationController
  def index
    regexp = %r{(?<=rooms\/)\h{10}}
    referer = request.referer

    # Проверка предыдущего запроса после выполнения фоновой задачи на удаление приватной комнаты
    # Условие 1: Пользователь открыл браузер и зашёл на сайт
    # Условие 2: Корректное отображение сообщения после выполнения фоновой задачи на удаление приватной комнаты
    if referer.nil?
      flash.now[:notice] = ''
    elsif referer != root_url && referer != new_room_url && Room.find_by_token(referer[regexp]).nil?
      flash.now[:notice] = 'Room expiration time is over'
    end

    @rooms = Room.includes(:users)
  end

  def show
    @room = Room.includes(messages: :user).find_by_token(params[:token])
    password_guard! if @room.is_private? && @room.user != current_user
  end

  def create
    @room = Room.new(room_params.merge(user: current_user))

    if @room.save
      DestroyPrivateRoomJob.set(wait: @room.expiration.minutes).perform_later(@room) if @room.is_private?

      ActionCable.server.broadcast('room_management_channel', room: @room.as_json(only: %i[id is_private token]),
                                                              status: 'created')

      redirect_to(@room, notice: 'Room was successfully created')
    else
      render(:new)
    end
  end

  def new
    @room = Room.new
  end

  def update
    @room = Room.find_by_token(params[:token])

    if @room.update(room_params)
      redirect_to(@room, notice: 'Room password was successfully updated')
    else
      render(:show)
    end
  end

  private

  def password_guard!
    if params[:password].present? && @room.password_valid?(params[:password])
      cookies.permanent["rooms_#{@room.id}_password"] = params[:password]
    end

    return true if @room.password_valid?(cookies.permanent["rooms_#{@room.id}_password"])

    flash.now[:notice] = 'Wrong password!' if params[:password].present?
    render('password_form')
  end

  def room_params
    params.require(:room).permit(:is_private, :expiration, :password)
  end
end
