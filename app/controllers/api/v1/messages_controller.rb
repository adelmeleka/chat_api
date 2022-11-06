class Api::V1::MessagesController < Api::ApiController
  before_action :set_application  
  before_action do validate_record_presence(@application) end
  before_action :set_chat
  before_action do validate_record_presence(@chat) end
  before_action :set_message, except: %i[index]
  before_action only: %i[show] do validate_record_presence(@message) end
  
  def create
    # Prepare data
    new_message_data = {
      "application": @application,
      "chat_number": @chat.chat_number,
      "message_no": @message.message_number,
      "message_content": @message.message_content
    }
    # Broadcast the new message to its appropriate channel
    ActionCable.server.broadcast "chats_#{@chat.id}", new_message_data.as_json
    # Save data to db using an active job
    MessageReplayJob.perform_later(new_message_data)
    # cache created message in redis (serialized)
    $redis.set("#{@application.application_token}_#{@chat.chat_number}_#{@message.message_number}", Marshal.dump(@message), ex: 3600) 
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
    if params[:message_number].present? 
      # Get cached copy from redis (deserialized) with an updated messages_count
      cached_msg = $redis.get("#{@application.application_token}_#{@chat.chat_number}_#{params[:message_number]}")
      if !cached_msg.nil?
        @message = Marshal.load(cached_msg)
      else
        #If not found, get it from db & save it in cache
        @message = @chat.messages.find_by(message_number: params[:message_number])
        $redis.set("#{@application.application_token}_#{@chat.chat_number}_#{params[:message_number]}", Marshal.dump(@message), ex: 3600) 
      end
    else
      # Only for create endpoint
      @message = Message.new(message_params)
      @message.message_number = get_new_message_number
    end
  end
  
  def get_new_message_number
    # Get/increment message number from redis
    if $redis.get("#{@application.application_token}_#{@chat.chat_number}_count").to_i >= 1
      message_number = $redis.incr("#{@application.application_token}_#{@chat.chat_number}_count")
    else
      $redis.set("#{@application.application_token}_#{@chat.chat_number}_count", @chat.messages_count+1)
      message_number =  @chat.messages_count+1
    end
    return message_number
  end
end
