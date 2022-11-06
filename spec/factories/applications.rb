FactoryBot.define do
  factory :application do
    name { Faker::Lorem.words(number: rand(2..10)) }
    application_token { Faker::Lorem.words(number: rand(10..25)) }
    chats_count { 0 }
  end
end