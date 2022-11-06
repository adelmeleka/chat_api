class Api::ApiController < ActionController::API
  include Api::Response
  # before_action :authenticate_request

  private

  def authenticate_request
    return if AuthorizeApiRequest.call(request.headers).result
    json_response({message: 'incorrect api key'}, :unauthorized)
  end

  def validate_record_presence(record)
    if record.nil? ||
      (record.is_a?(Application) && record.application_token.nil?) ||
      (record.is_a?(Chat) && record.chat_number.nil?)||
      (record.is_a?(Message) && record.message_number.nil?)
      return  json_response({}, :not_found) 
    end
  end

  def set_application
    @application = Application.find_by(application_token: params[:application_token]) if params[:application_token].present?
  end

  def set_chat
    if params[:chat_number].present? 
      # Get cached copy from redis (deserialized) with an updated messages_count
      cached_chat = $redis.get("#{@application.application_token}_#{params[:chat_number]}")
      if !cached_chat.nil?
        @chat =  Marshal.load(cached_chat)
        @chat.messages_count = $redis.get("#{@application.application_token}_#{@chat.chat_number}_count").to_i
      else
        #If not found, get it from db & save it in cache
        @chat = @application.chats.find_by(chat_number: params[:chat_number].to_i) 
        $redis.set("#{@application.application_token}_#{@chat.chat_number.to_s}", Marshal.dump(@chat), ex: 3600)
      end
    end
  end

end