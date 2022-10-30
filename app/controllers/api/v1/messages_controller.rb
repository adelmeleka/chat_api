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
    @message.chat = @chat
    @message.message_number = @chat.messages.length+1
    if @message.save
      @chat.update(messages_count: @chat.messages_count+1)
      json_response({data: @message.as_json}, :ok)
    else
      json_response(ErrorsSerializer.new(@message).serialize, :unprocessable_entity)
    end
  end

  def index
    json_response({data: @chat.messages.as_json, count: @chat.messages.length}, :ok)
  end

  def show
    json_response({data: @message.as_json}, :ok)
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
