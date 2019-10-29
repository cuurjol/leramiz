FactoryBot.define do
  factory :message do
    association(:user)
    association(:room)
    body { 'Random message' }
  end
end
