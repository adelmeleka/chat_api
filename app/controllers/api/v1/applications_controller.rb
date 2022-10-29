class Api::V1::ApplicationsController < Api::ApiController
  def create
    app = Application.new(application_token: Base64.encode64("app1-#{Application.all.length+1}"), name: params[:name])
    app.save
    render json: {message: 'Application created succesfully', application_token: app.application_token, application_name: app.name, chat_count: app.chats_count}, status: :ok
  end

end