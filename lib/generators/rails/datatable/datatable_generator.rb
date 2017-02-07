class DatatableGenerator < Rails::Generators::NamedBase

  def create_datatable_file
    columns = "#{class_name}".constantize.send("column_names")
    column_data = []
    columns.each do |col|
      column_data << "\"#{plural_name}__#{col}\" => #{plural_name.singularize}.#{col}"
    end

    create_file "app/datatables/#{file_name}_datatable.rb", <<-FILE
class #{class_name}Datatable
  delegate :controller, :url_for, :render, :params, :image_tag, :h, :link_to, :api_call_path, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
    @total_#{plural_name} = #{class_name}.count(:all)
    @#{plural_name} = #{class_name}.select(select_string).where(search_string, search: "%\#{params[:sSearch].to_s.downcase}%").order("\#{sort_column} \#{sort_direction}")
    @filtered_total = @#{plural_name}.size
    @#{plural_name} = @#{plural_name}.page(page).per_page(per_page)
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalDisplayRecords: @filtered_total,
      aaData: data,
      iTotalRecords: @total_#{plural_name},
    }
  end

private
  def data
    @#{plural_name}.map do |#{plural_name.singularize}|
      {
        DT_RowId: #{plural_name.singularize}.id.to_s,
        DT_RowClass: nil,
        DT_RowAttr: { },
        #{column_data.join(",\n\t\t\t\t")},
        #{plural_name}_actions: actions(#{plural_name.singularize}),
      }
    end
  end

  def actions(#{plural_name.singularize})
    render(:partial=>"#{plural_name}/actions.html.erb", locals: { #{plural_name.singularize}: #{plural_name.singularize}} , :formats => [:html]) if params[:table_view_mode] == 'table'
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
    col = [*0..params[:iColumns].to_i-1].map{|i| params["mDataProp_\#{i}"].gsub("__", ".") if params["bSortable_\#{i}"] != 'false' }[params[:iSortCol_0].to_i]
    if !col.blank?
      object, field = col.split('.')
      if !field.blank? && !object.blank?
        map = {"#{class_name}" => #{class_name}}
        field_type = map[object.classify].column_for_attribute(field).type
        return [:string, :text].include?(field_type) ? "lower(\#{col})" : col
      else
        return col
      end
    else
      return  "#{plural_name}.id"
    end
  end

  def sort_direction
    params[:sSortDir_0] == "asc" ? "asc" : "desc"
  end

  def search_string
    "to_char(#{plural_name}.id, '999999999') LIKE :search "
  end

  def select_string
    "#{plural_name}.*"
  end
end
    FILE
  end


end
