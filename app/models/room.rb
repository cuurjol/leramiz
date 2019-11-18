class Room < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :room_users, dependent: :destroy
  has_many :users, through: :room_users
  belongs_to :user

  with_options if: :is_private? do |room|
    room.validates :expiration, :password, presence: true
    room.validates :expiration, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 36_000 }
    room.validates :password, length: { minimum: 6 }
  end

  scope :public_rooms, -> { where(is_private: false) }
  scope :private_rooms, -> { where(is_private: true) }

  before_create :generate_token

  def to_param
    token
  end

  def password_valid?(room_password)
    password == room_password
  end

  private

  def generate_token
    self.token = SecureRandom.hex(5)
  end
end
