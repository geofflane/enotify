# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
# config.action_view.cache_template_loading            = true

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false
config.action_mailer.delivery_method = :smtp

config.action_controller.relative_url_root = "/html/community/map/"

# IMAP configuration
IMAP_SERVER = {
  :host => '',
  :port => 143,
  :use_ssl => false,
  :username => '',
  :password => ''
}.freeze

# First, specify the Host that we will be using later for user_notifier.rb
HOST = 'http://nwcdc.org/html/community/map/'

# Third, add your SMTP settings
# SMTP settings
ActionMailer::Base.smtp_settings = {
  :address => "",
  :port => 25,
  :domain => "",
  :user_name => "",
  :password => "",
  :authentication => :plain
}

