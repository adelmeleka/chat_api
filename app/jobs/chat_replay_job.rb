class ChatReplayJob < ApplicationJob
    queue_as :default
  
    def perform(data)
        application = data[:application]
        chat = Chat.new(chat_number: data[:chat_no])
        chat.application = application
        if chat.save
            application.update(chats_count: application.chats_count+1) 
        end
    end
  end