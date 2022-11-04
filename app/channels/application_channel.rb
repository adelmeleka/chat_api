class ApplicationChannel < ApplicationCable::Channel
  # A method will get application to subscribe to the streams (chats) it is allowed to.
  def subscribed
    stop_all_streams
    stream_from "application_#{current_application.id.to_s}"
  end
  
  # A method to unsubscribe(cleanup) the application to all its streams (chats)
  def unsubscribed
    stop_all_streams
  end
end
