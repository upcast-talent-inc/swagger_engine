require_dependency "swagger_engine/application_controller"

module SwaggerEngine
  class SwaggersController < ApplicationController
    layout false

    before_action :load_json_files

    def index
      default_api = @json_files.first[0]
      if @json_files.size == 1
        redirect_to swagger_path(default_api)
      end
    end

    def show
      @id = params[:id]
      respond_to do |format|
        format.html { @swagger_json_url = swagger_path(@id, format: :json) }
        format.json { send_file_or_redirect }
      end
    end

    private

    def load_json_files
      @json_files ||= SwaggerEngine.configuration.json_files ||
                      { default: "#{ Rails.root }/lib/swagger_engine/swagger.json" }
    end

    def send_file_or_redirect
      @path = @json_files[@id.to_sym]

      if @path.start_with? '/'
        redirect_to @path
      else
        send_file @path, type: 'application/json', disposition: 'inline'
      end
    end
  end
end
