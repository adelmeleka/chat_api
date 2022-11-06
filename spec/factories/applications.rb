FactoryBot.define do
  factory :application do
    name { Faker::Lorem.words(number: rand(2..10)) }
    application_token { Base64.encode64("app-#{name}-#{Application.all.length+1}").strip }
    chats_count { 0 }
  end
end