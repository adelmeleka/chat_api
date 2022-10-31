class MessageRelayJob < ApplicationJob
    queue_as :default
  
    def perform(data)
        byebug  
        p 'in perform'
        chat = Chat.find(data['chat_id'])
        message = Message.new(message_params)
        message.chat = chat
        message.message_number = chat.messages.length+1
        if message.save
          chat.update(messages_count: @chat.messages_count+1)  
    end
  end