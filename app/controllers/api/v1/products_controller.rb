class Api::V1::ProductsController < Api::V1::APIBaseController
  before_action :set_product, only:  [:show]
  def index
    @products = Product.all
    @unfiltered_size = @products.size
    if params[:page].nil?
      @page = 1
    else
      @page = params[:page].to_i
    end
    if params[:page_length].nil?
      @page_length = 20
    else
      @page_length = params[:page_length].to_i
    end
    @products = @products.page(@page).per_page(@page_length)
    respond_to do |format|
      format.json {render :status => :ok}
    end
  end

  def show
    respond_to do |format|
      format.json {render :status => :ok}
    end
  end

  private
    def set_product
      @product = Product.find(params[:id])
    end
end
