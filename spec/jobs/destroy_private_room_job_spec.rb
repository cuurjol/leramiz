require 'rails_helper'

RSpec.describe DestroyPrivateRoomJob, type: :job do
  let!(:room) { FactoryBot.create(:room, expiration: 5, password: 'qwerty', is_private: true) }

  describe '#perform' do
    it 'returns the number of rooms equal to zero' do
      expect { described_class.perform_now(room) }.to change { Room.count }.from(1).to(0)
    end

    it 'matches with enqueued job' do
      Timecop.freeze(Time.now)
      described_class.set(wait: room.expiration.minutes).perform_later(room)

      expect(described_class).to have_been_enqueued.with(room).on_queue('default').at(Time.now + 5.minutes)
    end
  end
end
