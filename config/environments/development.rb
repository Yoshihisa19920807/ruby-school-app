require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded any time
  # it changes. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options).
  # config.active_storage.service = :local
  config.active_storage.service = :amazon

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # Uncomment if you wish to allow Action Cable access from any origin.
  # config.action_cable.disable_request_forgery_protection = true

  config.hosts << "cf1a67f7bf1b43329b1f5241e70fdf93.vfs.cloud9.eu-central-1.amazonaws.com"
  config.hosts << "localhost"
  config.hosts << "a0e16876060c.ngrok.io"
  # config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  config.action_mailer.default_url_options = { host: 'https://1c70c97566c046c9b9b3b8359c0e23d5.vfs.cloud9.ap-northeast-1.amazonaws.com'}
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :enable_starttls_auto => true,
    :address => "smtp.gmail.com",
    :port => 587,
    :domain => 'smtp.gmail.com',
    :user_name => "yoshi19920807@gmail.com",
    :password => "wbzqxbstvmfairbc",
    :authentication => 'login'
  }
  # Rails.application.config.middleware.use ExceptionNotification::Rack,
  #   email: {
  #     # deliver_with: :deliver, # Rails >= 4.2.1 do not need this option since it defaults to :deliver_now
  #     email_prefix: '[PREFIX] ',
  #     sender_address: %{"notifier" <notifier@example.com>},
  #     # ↓email address to send error message
  #     exception_recipients: %w{yoshi19920807@gmail.com}
  #   }
end
