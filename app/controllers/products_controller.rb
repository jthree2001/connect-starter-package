class ProductsController < ApplicationController
  def index
    @products = Product.all
    respond_to do |format|
      format.html {  }
      format.json { render json: ::ProductsDatatable.new(view_context) }
      format.js { }
    end
  end
end
