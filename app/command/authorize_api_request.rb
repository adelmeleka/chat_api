class AuthorizeApiRequest
  prepend SimpleCommand

  def initialize(headers = {}, x)
    @headers = headers
  end

  def call
    authorize_api_key
  end

  private

  attr_reader :headers

  def authorize_api_key
    decoded_api_key_token[:user] == "ChatSystem" if decoded_api_key_token
  end

  def decoded_api_key_token
    @decoded_api_key_token ||= JsonWebToken.decode(http_api_key_header) if http_api_key_header
  rescue JWT::ExpiredSignature
    puts 'ExpiredSignature'
  rescue JWT::VerificationError
    puts 'VerificationError'
  end

  def http_api_key_header
    return headers['API-Key'].split(' ').last if headers['API-Key'].present?
  end
end
