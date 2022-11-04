class ChatReplayJob < ApplicationJob
    queue_as :default
  
    def perform(data)
        application = Application.find(data['app_id'])
        chat = Chat.new()
        chat.application = application
        chat.chat_number = application.chats.length+1
        if chat.save
            application.update(chats_count: application.chats_count+1) 
        end
    end
  end