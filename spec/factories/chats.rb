FactoryBot.define do
    factory :chat do
        chat_number { Faker::Number.number(10) }
        messages_count { 0 }
        app_id nil
    end
end