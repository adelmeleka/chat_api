class Api::V1::ChatsController < Api::ApiController
  before_action :set_application  
  before_action :set_new_chat, except: %i[index]
  before_action do validate_record_presence(@application) end
  before_action only: %i[show] do validate_record_presence(@chat) end
  
  def create
    # broadcast the new message to its appropriate channel
    data = {}
    data["app_id"] = @application.id
    ActionCable.server.broadcast "application_#{@application.id}", data.as_json
    # Save data to db using an active job
    ChatReplayJob.perform_later(data)
    # TODO: return messge number from redis 
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
