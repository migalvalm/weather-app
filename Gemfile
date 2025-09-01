source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.2"

# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"

# Use postgresql as the database for Active Record
gem 'pg'

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Import JavaScript modules using logical names that map to versioned/digested files – directly from the browser
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 5.0", ">= 5.0.6"

gem "view_component"
gem "haml-rails"
gem "autoprefixer-rails"
gem "bootstrap-sass", '~> 3.4.1'
gem 'jquery-rails'
gem 'sassc-rails', '>= 2.1.0'
gem "recursive-open-struct"
gem 'sprockets-rails'

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Simple, but flexible HTTP client library [https://github.com/lostisland/faraday]
gem "faraday", "~> 2.7"


gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "kamal", require: false
gem "thruster", require: false
gem "image_processing", "~> 1.2"

group :development, :test do
  gem "pry-byebug"
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem 'dotenv-rails', groups: [:development, :test]
  gem 'annotate'
end

group :development do
  gem "web-console"
end

group :test do
  gem "rspec-rails"
  gem "capybara"
  gem "selenium-webdriver"
  gem "factory_bot_rails"
  gem "webmock"
  gem "vcr"
  gem "mocha"
  gem "rails-controller-testing"
end

group :assets do
  gem 'sass-rails'
end

gem "geocoder", "~> 1.8"
