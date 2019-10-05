class User < ApplicationRecord
  before_create :generate_nickname

  private

  def generate_nickname
    self.nickname = Faker::Name.first_name
  end
end
