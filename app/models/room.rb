class Room < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :room_users, dependent: :destroy
  has_many :users, through: :room_users

  before_create :generate_token

  def to_param
    token
  end

  private

  def generate_token
    self.token = SecureRandom.hex(5)
  end
end
