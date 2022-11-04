require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FirstApp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.active_job.queue_adapter = :sidekiq
    config.action_cable.disable_request_forgery_protection = true
    config.action_cable.url = "/cable"
    config.cache_store = :redis_cache_store, { url: "#{ENV['REDIS_URL']}/#{ENV.fetch('REDIS_DB')}" }
  end
end
