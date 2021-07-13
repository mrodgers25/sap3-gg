# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.7.3'
gem 'rails', '6.1.3.1 '
gem 'webpacker'

# NEW GEMS
# Pagination
gem 'pagy', '~> 3.5' # omit patch digit and use the latest if possible
# State Management
gem 'aasm'
# Bug Tracking
gem 'rollbar'
# Avoid all the crazy logins
gem 'recaptcha'
# S3 buckets
gem "aws-sdk-s3", require: false
# Image resizing
gem 'image_processing'

gem 'ancestry'
gem 'awesome_print', require: 'ap'
gem 'coffee-rails'
gem 'devise'
gem 'domainatrix'
gem 'fastimage'
gem 'figaro', '1.2.0'
gem 'geocoder'
gem 'google-webfonts'
gem 'high_voltage'
gem 'jbuilder', '<= 2.9.1'
gem 'json'
gem 'mail', '2.7.1'
gem 'nokogiri'
gem 'pg'
gem 'pg_search'
gem 'puma'
gem 'pundit', '>= 0.2.1'
gem 'rails_12factor', group: :production
gem 'responders'
gem 'rest-client'
gem 'sanitize'
gem 'sass-rails'
gem 'sdoc', group: :doc
gem 'sendgrid-ruby'
gem 'simple_form'
gem 'social-share-button'
gem 'turbolinks'
gem 'uglifier', '>= 1.3.0'
gem 'unirest'

# new with RAILS 5
gem 'bootsnap', '>= 1.4.2', require: false

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'better_errors'
  gem 'binding_of_caller', platforms: [:mri_21]
  gem 'hub', require: nil
  gem 'railroady'
  gem 'rails_layout'
  gem 'spring'
  # This will create an ERD diagram from your database
  gem 'rails-erd'
  # test new viewing database option
  gem 'rails_db'
  # new with RAILS 5
  gem 'listen'

  # NEW GEMS
  # Email Catcher for Dev
  gem 'letter_opener'

end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :test do
  gem 'faker'
  # Debugging/Console
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'shoulda-matchers', '~> 4.0'
end

gem 'activerecord-nulldb-adapter'
