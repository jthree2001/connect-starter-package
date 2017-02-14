ZuoraConnect.configure do |config|
  config.private_key = Rails.application.secrets.connect['key']
  config.mode = "Production" # Production Or Developmen
  config.delayed_job = true
end
Dir["#{Rails.root}/lib/workers/*.rb"].each {|file| require file }
