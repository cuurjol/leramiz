class User < ApplicationRecord
  before_create :generate_nickname

  scope :online, -> { where(online: true) }

  private

  def generate_nickname
    self.nickname = Faker::Name.first_name
  end
end
