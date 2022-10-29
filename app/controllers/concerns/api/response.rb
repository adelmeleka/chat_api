module Api::Response extend ActiveSupport::Concern
  
    def json_response(object, status = :ok, options = nil)
      object ||= {}
      object = object.merge(options) if options.present?
  
      render json: object.as_json, status: status
    end
  end
  