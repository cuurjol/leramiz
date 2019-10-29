FactoryBot.define do
  factory :room do
    token { SecureRandom.hex(5) }
  end
end