FactoryBot.define do
  factory :application do
    name { Faker::Lorem.word }
    application_token { Faker::Lorem.word }
    chats_count 0
  end
end