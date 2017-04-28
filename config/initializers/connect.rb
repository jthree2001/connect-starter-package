GELF::Logger.send :include, ActiveRecord::SessionStore::Extension::LoggerSilencer
#If using delayedjob
#Delayed::Backend::ActiveRecord::Job.logger.level = 1
#
Rails.application.configure do
 config.lograge.enabled = true
 config.lograge.formatter = Lograge::Formatters::KeyValue.new
 config.lograge.custom_options = lambda do |event|
   exceptions = %w(controller action format id)
   {
     params: event.payload[:params].except(*exceptions),
     exception: event.payload[:exception],
     exception_object: event.payload[:exception_object]
   }
 end
end

ZuoraConnect.configure do |config|
  config.private_key = Rails.application.secrets.connect['key']
  config.delayed_job = true

  if Rails.env == "development"
    config.mode = "Development" # Production Or Development
    config.dev_mode_logins = { "target_login" => {"tenant_type" => "Zuora", "username" => Rails.application.secrets.starter_pack["zuora_login"], "password" => Rails.application.secrets.starter_pack["zuora_password"], "url" => Rails.application.secrets.starter_pack["zuora_url"]} } # If dev mode set mockup request logins
    config.dev_mode_options = {"name" => {"config_name" => "name", "datatype" => "type", "value" => "value"}} #If dev mode set mock up request options
    config.dev_mode_mode = "Universal" #If dev mode set application run mode
    config.dev_mode_admin = true
  end

end
Dir["#{Rails.root}/lib/workers/*.rb"].each {|file| require file }
