class Admin::AppInstancesController < Admin::ApplicationController
  before_action :set_app_instance, only: [:show, :edit, :update, :message]

  def index
    respond_to do |format|
      format.html { }
      format.json { render json: ZuoraConnect::AppInstanceDatatable.new(view_context) }
      format.js { }
    end
  end

  def show
    switch_instances
  end

  private
  def set_app_instance
    @app_instance = ZuoraConnect::AppInstance.find(params[:id])
  end

  def switch_instances
    session["#{@app_instance.id}::valid"] = session["#{session['appInstance']}::valid"]
    session["#{@app_instance.id}::admin"] = session["#{session['appInstance']}::admin"]
    session["#{@app_instance.id}::user::timezone"] = session["#{session['appInstance']}::user::timezone"]
    session["#{@app_instance.id}::user::locale"] = session["#{session['appInstance']}::user::locale"]
    session["#{@app_instance.id}::user::email"] = session["#{session['appInstance']}::user::email"]
    session["appInstance"] = @app_instance.id.to_s
    @app_instance.reload.new_session

    respond_to do |format|
      format.html { redirect_to root_path, notice: "Switched to App Instance #{session['appInstance']}" }
      format.js { render action: 'redraw' }
    end
  end
end
