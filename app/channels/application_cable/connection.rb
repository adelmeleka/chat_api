module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_application
    
    # Finds the current app and returns it else it returns unauthorized
    def find_verified_application application_token
      application = Application.find_by(application_token: application_token)
      unless application.nil?
        return application
      else
        return reject_unauthorized_connection
      end
    end

    # Assuming that application_token is coming in request as query params    
    # The connect method searches for the application with right token
    #  or else rejects the connection to the socket.
    def connect
      self.current_application = find_verified_application request.params[:application_token]
      logger.add_tags 'ActionCable', current_application.id
    end

  end
end
