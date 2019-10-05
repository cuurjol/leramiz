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

    redirect_to(@room, notice: 'Room was successfully created')
  end
end
