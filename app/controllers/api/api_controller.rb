class Api::ApiController < ActionController::API
  include Api::Response
  before_action :authenticate_request

  private

  def authenticate_request
    return if AuthorizeApiRequest.call(request.headers).result
    json_response({message: 'incorrect api key'}, :unauthorized)
  end

  def validate_record_presence(record)
    return  json_response({}, :not_found) if record.nil?
  end

  def set_application
    @application = Application.find_by(application_token: params[:application_token]) if params[:application_token].present?
  end

  def set_chat
    @chat = @application.chats.find_by(chat_number: params[:chat_number].to_i) if params[:chat_number].present?
  end

end