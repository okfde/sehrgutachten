require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Sehrgutachten
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    config.i18n.available_locales = :de
    config.i18n.default_locale = :de

    config.active_job.queue_adapter = :sidekiq
    config.active_job.queue_name_prefix = "sehrgutachten_#{Rails.env}"

    # applicaton config:
    # path for storing paper pdfs
    config.x.paper_storage = Rails.root.join('data')
    # User-Agent for scraping and download
    config.x.user_agent = 'sehrgutachten-scraper (info@sehrgutachten.de)'
    # Tika Server URL for extracting text from papers
    config.x.tika_server = ENV['TIKA_SERVER_URL'] || false
    # Push OCR token to update paper contents from remote
    config.x.push_ocr_token = ENV['PUSH_OCR_TOKEN']
  end
end
