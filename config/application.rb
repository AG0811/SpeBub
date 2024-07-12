require_relative "boot"

require "rails/all"

# OpenWeatherMap
require 'dotenv-rails'

# Dotenv::Railtie.load
Dotenv::Rails.load

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SpeBub
  class Application < Rails::Application
    config.load_defaults 7.0
    config.time_zone = "Tokyo"
  end
end
