require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # Use Terser for JavaScript compression
  # If you want to keep using Uglifier, ensure the harmony mode is enabled.
  # Uncomment the one you want to use.
  
  # config.assets.js_compressor = Uglifier.new(harmony: true)
  config.assets.js_compressor = :terser

  config.assets.compile = true
  config.assets.precompile += %w( application.js application.css )
  config.active_storage.service = :local
  config.force_ssl = true

  config.logger = ActiveSupport::Logger.new(STDOUT)
    .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
    .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  config.log_tags = [ :request_id ]
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")
  config.action_mailer.perform_caching = false
  config.i18n.fallbacks = true
  config.active_support.report_deprecations = false

  config.hosts << "lpvckqg9-3000.aue.devtunnels.ms"

  config.active_record.dump_schema_after_migration = false
  config.assets.digest = true
end
