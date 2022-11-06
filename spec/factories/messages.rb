FactoryBot.define do
    factory :messge do
        message_number { Faker::Number.number(10) }
        message_content { Faker::Lorem.word }
        chat_id nil
    end
end