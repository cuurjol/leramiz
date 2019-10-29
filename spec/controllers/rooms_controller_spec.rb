require 'rails_helper'

RSpec.describe RoomsController, type: :controller do
  render_views

  let(:user) { FactoryBot.create(:user, nickname: 'Francisco') }

  before(:each) do
    allow_any_instance_of(User).to receive(:generate_nickname)
    cookies.signed[:user_id] = user.id
  end

  describe '#index' do
    context 'when list of rooms will be showed' do
      before(:each) { FactoryBot.create_list(:room, 3) }
      before(:each) { get(:index) }

      it 'returns list of rooms' do
        expect(assigns(:rooms)).to_not be_nil
        expect(assigns(:rooms).count).to eq(3)
      end

      it 'renders index view' do
        expect(response.status).to eq(200)
        expect(response).to render_template(:index)
        expect(response.body).to match('Welcome to Leramiz, <b>Francisco</b>!')
        expect(response.body).to match('Online: Francisco')
        expect(response.body).to match('Rooms')
        expect(response.body).to match("Room ##{Room.first.id}")
        expect(response.body).to match("Room ##{Room.second.id}")
        expect(response.body).to match("Room ##{Room.third.id}")
      end
    end
  end

  describe '#show' do
    context 'when existing room will be showed' do
      let(:room) { FactoryBot.create(:room, token: 'dc15461a15') }

      before(:each) do
        allow_any_instance_of(Room).to receive(:generate_token)
        (1..3).each { |i| FactoryBot.create(:message, body: "Random message ##{i}", room: room, user: user) }
        RoomUser.create(room: room, user: user)
        get(:show, params: { token: room.token })
      end

      it 'returns room with 3 messages from user' do
        expect(assigns(:room)).to_not be_nil
        expect(assigns(:room)).to have_attributes(token: 'dc15461a15')
        expect(assigns(:room).messages.count).to eq(3)
      end

      it 'returns show view' do
        expect(response.status).to eq(200)
        expect(response).to render_template(:show)
        expect(response.body).to match('Welcome to Leramiz, <b>Francisco</b>!')
        expect(response.body).to match('Room users: Francisco')
        expect(response.body).to match("Room #{Room.first.id}")
        expect(response.body).to match('Random message #1')
        expect(response.body).to match('Random message #2')
        expect(response.body).to match('Random message #3')
      end
    end
  end

  describe '#create' do
    context 'when new room will be created' do
      it 'successfully creates new room' do
        expect { post(:create) }.to change { Room.count }.from(0).to(1)
      end

      it 'redirects to show view' do
        post(:create)
        expect(response.status).to eq(302)
        expect(response).to redirect_to(Room.first)
        expect(flash[:notice]).to eq('Room was successfully created')
      end
    end
  end
end
