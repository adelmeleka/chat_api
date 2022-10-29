class Api::ApiController < ActionController::API
  before_action :authenticate_request

  private

  def authenticate_request
    return if AuthorizeApiRequest.call(request.headers).result

    render json: {message: 'incorrect api key'}, status: :unauthorized
  end
end