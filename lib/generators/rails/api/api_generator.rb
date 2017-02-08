class ApiGenerator < Rails::Generators::NamedBase

  def create_API_file

    require 'active_record'
    require 'pg'

    configuration = YAML::load(IO.read('config/database.yml'))
    ActiveRecord::Base.establish_connection(configuration['development'])

    columns = "#{class_name.singularize}".constantize.send("column_names")
    json_data = []
    columns.each do |col|
      json_data << "json.#{col} #{plural_name.singularize}.#{col}"
    end
#create the controller
    create_file "app/controllers/api/v1/#{file_name}_controller.rb", <<-FILE
      class Api::V1::#{class_name}Controller < Api::V1::APIBaseController
        before_action :set_#{plural_name.singularize}, only:  [:show]
        def index
          @#{plural_name} = #{class_name.singularize}.all
          @unfiltered_size = @#{plural_name}.size
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
          @#{plural_name} = @#{plural_name}.page(@page).per_page(@page_length)

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
          def set_#{plural_name.singularize}
            @#{plural_name.singularize} = #{class_name.singularize}.find(params[:id])
          end

      end

    FILE


#create views
    create_file "app/views/api/v1/#{file_name}/_#{file_name.singularize}.json.jbuilder", <<-FILE
      #{json_data.join("\n")},
    
    FILE

    create_file "app/views/api/v1/#{file_name}/index.json.jbuilder", <<-FILE

      json.#{plural_name} do
        json.array! @#{plural_name} do |#{plural_name.singularize}|
          json.partial! 'api/v1/#{plural_name}/#{plural_name.singularize}', #{plural_name.singularize}: #{plural_name.singularize}
        end
      end
      json.pagination do
        json.page @page
        json.page_length @page_length
        json.total_filtered_records @#{plural_name}.size
        json.total_records @unfiltered_size
      end

    FILE


    create_file "app/views/api/v1/#{file_name}/show.json.jbuilder", <<-FILE
      json.partial! 'api/v1/#{plural_name}/#{plural_name.singularize}', #{plural_name.singularize}: @#{plural_name.singularize}

    FILE

  end

end
