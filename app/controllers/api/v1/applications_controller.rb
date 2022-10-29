class Api::V1::ApplicationsController < Api::ApiController
  before_action :set_application, except: %i[index]
  before_action only: %i[show update] do
    validate_record_presence(@application)
  end

  def create
    @application.application_token = Base64.encode64("app-#{@application.name}").strip
    if @application.save
      # brodcasting in channel
      json_response({data: @application.as_json}, :ok)
    else
      json_response(ErrorsSerializer.new(@application).serialize, :unprocessable_entity)
    end
  end

  def index
    applications = Application.all
    if applications
      json_response({data: applications.as_json, count: applications.length}, :ok)
    else
      json_response(ErrorsSerializer.new(applications).serialize, :unprocessable_entity)
    end
  end

  def update
    if @application.update(application_params)
      json_response({data: @application.as_json}, :ok)
    else
      json_response(ErrorsSerializer.new(@application).serialize, :unprocessable_entity)
    end
  end

  def show
    json_response({data: @application.as_json}, :ok)
  end

  private

  def application_params
    params.require(:application).permit(:name)
  end

  def set_application
    byebug
    @application = params[:application_token].present? ? 
      Application.find_by(application_token: params[:application_token]) :
      Application.new(application_params)
  end

end