require File.expand_path('../boot', __FILE__)

require 'rails/all'

if ENV.has_key?("PROCESS_TYPE")
  # If we do, assuming its a comma seperated list
  ENV["PROCESS_TYPE"].split(",").each { |type|
      # Require the current process type, and
      # current process type and environment joined by an underscore
      Bundler.require(type, "#{type}_#{Rails.env}")
  }
end

module WorkflowEngine
  class Application < Rails::Application
    require "lograge"
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    config.active_job.queue_adapter = :delayed_job
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = ::Logger::Formatter.new
    config.logger = ActiveSupport::TaggedLogging.new(logger)
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

    config.generators do |g|
      g.jbuilder          false
      g.templates.unshift File::expand_path("../templates", File.dirname(__FILE__))
    end
  end
end
