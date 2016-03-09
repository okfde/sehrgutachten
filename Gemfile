source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '>= 5.0.0.beta2', '< 5.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# Action Cable dependencies for the Redis adapter
gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :test do
  gem 'sqlite3'
  gem 'memory_test_fix', path: "vendor/gems/memory_test_fix-1.2.1"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Get i18n files
gem 'rails-i18n', '~> 5.0.0.beta3'

# scraping
gem 'mechanize', '~> 2.7.4'

# fix urls while scraping
gem 'addressable', '~> 2.4.0'

# slugs
gem 'friendly_id', '~> 5.1.0'

# styling
gem 'bootstrap-sass', '~> 3.3.6'

# pagination
gem 'kaminari', github: 'amatsuda/kaminari'

# httpclient
gem 'patron', '~> 0.5.0'
gem 'excon', '~> 0.45.4'

# pdf page count
gem 'docsplit', '~> 0.7.6'

# search
gem 'searchkick', '~> 1.2.1'
gem 'typhoeus', '~> 1.0.1'

# simple title and opengraph/twitter cards view helpers
gem 'tophat', '~>2.2.1'

# jobs
gem 'sidekiq', '~>4.1.1'
gem 'sinatra', github: 'sinatra/sinatra', ref: '4c7d38eb', require: nil # needs sinatra 2.0, because rack 2
