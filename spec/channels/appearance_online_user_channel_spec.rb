require 'rails_helper'

RSpec.describe AppearanceOnlineUserChannel, type: :channel do
  let(:user) { FactoryBot.create(:user, online: false) }

  before(:each) { stub_connection(current_user: user) }

  describe '#subscribed' do
    it 'subscribes to the AppearanceOnlineUser stream' do
      subscribe
      expect(subscription).to be_confirmed
      expect(subscription).to have_stream_from('appearance_online_user_channel')
      expect(user.online).to be_truthy
    end

    it 'sends online user notification' do
      expect(&method(:subscribe)).to have_broadcasted_to('appearance_online_user_channel')
        .with(users: [nickname: user.nickname])
    end
  end

  describe '#unsubscribed' do
    before(:each) { subscribe }

    it 'unsubscribes to the AppearanceOnlineUser stream' do
      expect(subscription).to have_stream_from('appearance_online_user_channel')
      expect(user.online).to be_truthy

      unsubscribe
      expect(subscription).not_to have_streams
      expect(user.online).to be_falsey
    end

    it 'sends offline user notification' do
      expect(&method(:unsubscribe)).to have_broadcasted_to('appearance_online_user_channel')
        .with(users: [])
    end
  end
end
