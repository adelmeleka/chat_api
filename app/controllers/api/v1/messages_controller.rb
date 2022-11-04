class Api::V1::MessagesController < Api::ApiController
  before_action :set_application  
  before_action :set_chat
  before_action :set_message, except: %i[index]
  before_action do 
    validate_record_presence(@application)
    validate_record_presence(@chat) 
  end
  before_action only: %i[show] do validate_record_presence(@message) end
  
  def create
    # broadcast the new message to its appropriate channel
    # TODO: return messge number from redis 
    data = {}
    data["chat_id"] = @chat.id
    data["message_content"] = @message.message_content
    # ActionCable.server.broadcast "chats_#{@chat.id}", data.as_json
    # Save data to db using an active job
    MessageReplayJob.perform_later(data)
    # TODO: return messge number from redis 
    # get & increment value from redis
    json_response({data: @message.as_json}, :ok)
  end

  def index
    json_response({data: @chat.messages.as_json, count: @chat.messages.length}, :ok)
  end

  def show
    json_response({data: @message.as_json}, :ok)
  end

  def search
    if params[:search_content].present? && @chat 
      json_response({data:@chat.messages.where("message_content like ?", "%#{params[:search_content]}%").as_json}, :ok)
    else
      json_response(ErrorsSerializer.new(@chat).serialize, :unprocessable_entity)
    end 
  end

  private

  def message_params
    params.permit(:message_content)
  end

  def set_message
    @message = params[:message_number].present? ?
      @chat.messages.find_by(message_number: params[:message_number]):
      Message.new(message_params)
  end
end
