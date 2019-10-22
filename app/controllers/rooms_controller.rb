class RoomsController < ApplicationController
  def index
    @rooms = Room.all
    @room = Room.new
  end

  def show
    @room = Room.includes(messages: :user).find_by_token(params[:token])
  end

  def create
    @room = Room.create!

    ActionCable.server.broadcast('appearance_new_room_channel', room: render_room)

    redirect_to(@room, notice: 'Room was successfully created')
  end

  private

  def render_room
    ApplicationController.renderer.render(partial: 'rooms/room', locals: { room: @room })
  end
end
