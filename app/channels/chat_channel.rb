class ChatChannel < ApplicationCable::Channel
  
  # A method will get application to subscribe to the streams (chats) it is allowed to.
  def subscribed
    stop_all_streams
    Chat.where(application_id: current_application.id).find_each do |chat|
      stream_from "chats_#{chat.id.to_s}"
    end
  end
  
  # A method to unsubscribe(cleanup) the application to all its streams (chats)
  def unsubscribed
    stop_all_streams
  end

  # Called when cable receives a brodcasted message. 
  # Take this message & save it to database
  # def receive(data)
  #   byebug
  #   p 'in recieve'
  #   MessageRelayJob.perform_later(data)
  # end

end
