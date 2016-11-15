class ProductsDatatable
  delegate :controller, :url_for, :render, :params, :image_tag, :h, :link_to, :api_call_path, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
    @total_products = Product.count(:all)
    @products = Product.select(select_string).where(search_string, search: "%#{params[:sSearch].to_s.downcase}%").order("#{sort_column} #{sort_direction}")
    @products = @products.where(:id => params["product_name"]) if params["product_name"]
    @filtered_total = @products.size
    @products = @products.page(page).per_page(per_page)
  end
  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalDisplayRecords: @filtered_total,
      aaData: data,
      iTotalRecords: @total_products,
    }
  end

private
  def data
    @products.map do |product|
      {
        DT_RowId: product.id.to_s,
        DT_RowClass: nil,
        DT_RowAttr: { },
        "products__id" => product.id,
        "products__name" => product.name,
        "products__price" => product.price,
        "products__category" => product.category,
        products_actions: actions(product),
      }
    end
  end

  def actions(product)
    render(:partial=>"products/actions.html.erb", locals: { product: product} , :formats => [:html]) if params[:table_view_mode] == 'table'
  end

  def display_time(time)
    return !time.to_s.blank? ? Time.parse(time.to_s).strftime("%m/%d/%y  %I:%M:%S %p") : ''
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    col = [*0..params[:iColumns].to_i-1].map{|i| params["mDataProp_#{i}"].gsub("__", ".") if params["bSortable_#{i}"] != 'false' }[params[:iSortCol_0].to_i]
    if !col.blank?
      object, field = col.split('.')
      if !field.blank? && !object.blank?
        map = {"Product" => Product}
        field_type = map[object.classify].column_for_attribute(field).type
        return [:string, :text].include?(field_type) ? "lower(#{col})" : col
      else
        return col
      end
    else
      return  "products.id"
    end
  end

  def sort_direction
    params[:sSortDir_0] == "asc" ? "asc" : "desc"
  end

  def search_string
    "to_char(products.id, '999999999') LIKE :search OR
    lower(products.name) LIKE :search OR
    lower(products.category) LIKE :search OR
    products.price LIKE :search"
  end

  def select_string
    "products.*"
  end
end
