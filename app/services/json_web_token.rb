class JsonWebToken
  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s
  class << self
    def encode(payload, exp = 1.year.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, SECRET_KEY)
    end

    def decode(token)
      decoded = JWT.decode(token, SECRET_KEY)[0]
      HashWithIndifferentAccess.new decoded
    rescue StandardError => e
      puts e
    end
  end
end
