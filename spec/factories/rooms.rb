FactoryBot.define do
  factory :room do
    token { SecureRandom.hex(5) }
    expiration { nil }
    password { nil }
    is_private { false }
    association(:user)
  end
end
