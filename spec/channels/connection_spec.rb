require 'rails_helper'

RSpec.describe ApplicationCable::Connection, type: :channel do
  let(:user) { FactoryBot.create(:user) }

  it 'rejects connection' do
    cookies.signed[:user_id] = nil

    expect { connect('/cable') }.to have_rejected_connection
  end

  it 'successfully connects' do
    cookies.signed[:user_id] = user.id

    connect('/cable')
    expect(connection.current_user).to eq(user)
  end
end
