class Admin::AppInstancesController < Admin::ApplicationController
  before_action :set_app_instance, only: [:edit, :update, :message]

  def index

    client = @appinstance.target_login.client
    @response = client.getDataSourceExport("Select id from account")


    respond_to do |format|
      format.html { }
      format.json { render json: ::AppInstancesListDatatable.new(view_context) }
      format.js { }
    end
  end

  private
    def set_app_instance
      @app_instance = ZuoraConnect::AppInstance.find(params[:id])
    end
end
