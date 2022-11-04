class Api::V1::ChatsController < Api::ApiController
  before_action :set_application  
  before_action :set_new_chat, except: %i[index]
  before_action do validate_record_presence(@application) end
  before_action only: %i[show] do validate_record_presence(@chat) end
  
  def create
    # Return chat number from redis 
    if $redis.get("#{@application.application_token}_count").to_i >= 1
      chat_number = $redis.incr("#{@application.application_token}_count")
    else
      $redis.set("#{@application.application_token}_count", @application.chats_count+1)
      chat_number = @application.chats_count+1
    end
    @chat.chat_number = chat_number
    # broadcast the new chat to its appropriate channel
    data = {}
    data["app_id"] = @application.id
    data["chat_no"] = chat_number
    ActionCable.server.broadcast "application_#{@application.id}", data.as_json
    # Save data to db using an active job
    ChatReplayJob.perform_later(data)
    #return response
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
    @chat = Chat.new(application_id: @application.id) if @chat.nil?
  end
end
