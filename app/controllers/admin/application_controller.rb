class Admin::ApplicationController < ApplicationController
  before_filter :check_connect_admin!

  def delayedjob

  end
end
