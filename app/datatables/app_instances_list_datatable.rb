class AppInstancesListDatatable
  delegate :controller, :url_for, :render, :params, :image_tag, :h, :link_to, :api_call_path, :number_to_currency, to: :@view

  def initialize(view)
    @view = view

    @total_instances = ZuoraConnect::AppInstance.count(:all)

    @instances = ZuoraConnect::AppInstance.select(select_string).where(search_string, search: "%#{params[:sSearch].to_s.downcase}%").order("#{sort_column} #{sort_direction}")

    @filtered_total = @instances.size

    @instances = @instances.page(page).per_page(per_page)
  end


  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalDisplayRecords: @filtered_total,
      aaData: data,
      iTotalRecords: @total_instances,
    }
  end

private
  def data
    @instances.map do |instance|
      {
        DT_RowId: instance.id.to_s,
        DT_RowClass: nil,
        DT_RowAttr: { },
        "zuora_connect_app_instances__id" => instance.id,
        grid_view: nil,
      }
    end
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
        map = {"ZuoraConnectAppInstance" => ZuoraConnect::AppInstance}
        field_type = map[object.classify].column_for_attribute(field).type
        return [:string, :text].include?(field_type) ? "lower(#{col})" : col
      else
        return col
      end
    else
      return  "zuora_connect_app_instances.id"
    end
  end

  def sort_direction
    params[:sSortDir_0] == "asc" ? "asc" : "desc"
  end

  def search_string
    "to_char(zuora_connect_app_instances.id, '999999999') LIKE :search OR
    (zuora_connect_app_instances.emails)::jsonb ? :search OR
    lower(zuora_connect_app_instances.notes) LIKE :search OR
    (zuora_connect_app_instances.limits)::jsonb ?  :search"
  end

  def select_string
    "zuora_connect_app_instances.*"
  end
end
