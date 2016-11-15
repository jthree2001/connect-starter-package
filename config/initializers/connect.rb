ZuoraConnect.configure do |config|
  config.private_key = Rails.application.secrets.connect['key']
  config.mode = "Development" # Production Or Development
  config.dev_mode_logins = { "target_login" => {"tenant_type" => "Zuora", "username" => Rails.application.secrets.starter_pack["zuora_login"], "password" => Rails.application.secrets.starter_pack["zuora_password"], "url" => Rails.application.secrets.starter_pack["zuora_url"]} } # If dev mode set mockup request logins
  config.dev_mode_options = {"name" => {"config_name" => "name", "datatype" => "type", "value" => "value"}} #If dev mode set mock up request options
  config.dev_mode_mode = "Universal" #If dev mode set application run mode
  config.dev_mode_admin = true
  config.delayed_job = true
end
Dir["#{Rails.root}/lib/workers/*.rb"].each {|file| require file }
