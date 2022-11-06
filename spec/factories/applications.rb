FactoryBot.define do
    factory :application do
      name { Faker::Lorem.word }
      application_token { Faker::Lorem.word }
    end
end