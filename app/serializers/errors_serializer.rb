class ErrorsSerializer
    attr_reader :record
  
    def initialize(record)
      @record = record
    end
  
    def serialize
      record.errors.details.map do |field, details|
        details.map do |error_details|
          {
            resource: @record.class.to_s,
            field: field.to_s,
            code: error_details[:error].to_s,
            message: record.errors.generate_message(field, error_details[:error].to_sym)
          }
        end
      end.flatten
    end
  end