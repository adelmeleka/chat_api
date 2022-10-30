class Api::V1::ChatsController < Api::ApiController
  before_action :set_application  
  before_action :set_new_chat, except: %i[index]
  before_action do validate_record_presence(@application) end
  before_action only: %i[show] do validate_record_presence(@chat) end
  
  def create
    @chat.chat_number = @application.chats.length+1
    if @chat.save
      @application.update(chats_count: @application.chats_count+1)
      json_response({data: @chat.as_json}, :ok)
    else
      json_response(ErrorsSerializer.new(@chat).serialize, :unprocessable_entity)
    end
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
