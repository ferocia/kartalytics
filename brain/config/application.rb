require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Leaguebot
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # https://stackoverflow.com/questions/71332602/upgrading-to-ruby-3-1-causes-psychdisallowedclass-exception-when-using-yaml-lo
    config.active_record.use_yaml_unsafe_load = true

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.active_record.belongs_to_required_by_default = false
  end
end

# fixes Psych::BadAlias (Unknown alias:) in googlecharts
# https://stackoverflow.com/a/71192990
module YAML
  class << self
    alias_method :load, :unsafe_load if YAML.respond_to? :unsafe_load
  end
end
