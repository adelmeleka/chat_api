class Api::V1::ChatsController < Api::ApiController
  before_action :set_application  
  before_action do validate_record_presence(@application) end
  before_action :set_new_chat, except: %i[index]
  before_action only: %i[show] do validate_record_presence(@chat) end
  
  def create
    #Prepare data
    new_chat_data = {
      "application": @application,
      "chat_no": @chat.chat_number
    }
    # Broadcast the new chat to its appropriate channel
    ActionCable.server.broadcast "application_#{@application.id}", new_chat_data.as_json
    # Save data to SQL db using an active job
    ChatReplayJob.perform_later(new_chat_data)
    # cache created chat in redis (serialized)
    $redis.set("#{@application.application_token}_#{@chat.chat_number}", Marshal.dump(@chat), ex: 3600) 
    # return response
    json_response({data: @chat.as_json}, :ok)
  end

  def index
    json_response({data: @application.chats.as_json, count: @application.chats.length}, :ok)
  end

  def show
    json_response({data: @chat.as_json}, :ok)
  end

  private

  def set_new_chat
    set_chat
    # Only for the case of create
    @chat = Chat.new(application_id: @application.id, chat_number: get_new_chat_number, messages_count: 0) if @chat.nil?
  end

  def get_new_chat_number
    # Get/increment chat number from redis
    if $redis.get("#{@application.application_token}_count").to_i >= 1
      chat_number = $redis.incr("#{@application.application_token}_count")
    else
      $redis.set("#{@application.application_token}_count", @application.chats_count+1)
      chat_number = @application.chats_count+1
    end
    chat_number
  end

end
