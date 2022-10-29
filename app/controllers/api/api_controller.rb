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

end