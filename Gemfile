source 'https://rubygems.org'
ruby '2.4.9' #this works
#ruby '2.5.7'  ## tried upgrading to this with Nate but then code broke
#ruby '2.2.4'
#ruby '2.1.4'
#upgrade to 4.2.0
gem 'rails', '4.2.11.1' #4.2.8'
gem 'rails_12factor', group: :production

#due to upgrade to 4.2.0 had to have version 4.0.3
#gem 'sass-rails', '~> 4.0.3'
gem 'sass-rails', '~> 5.0.6' #might need this version for Bootstap 3.3.7

#due to upgrade to 4.2.0
gem 'responders', '~> 2.0'

gem 'uglifier', '>= 1.3.0'

#due to upgrade to 4.2.0
# Use CoffeeScript for .coffee assets and views
#gem 'coffee-rails', '~> 4.0.0'
gem 'coffee-rails', '~> 4.1.0'

gem 'jquery-rails'
 gem 'turbolinks'
gem 'jbuilder', '~> 2.0'

gem 'sdoc', '~> 0.4.0', group: :doc

gem 'bootstrap-sass', '~> 3.3.7' #changed to 3.3.7 to go with Rails 4.2.0 #, '~> 3.2.0' had to hard code version number to get it to work with old versions of Rails and Ruby
gem 'devise', '~>3.5.10' #'4.2.0' # '~>3.5.5' #had to hard code version number to get it to work
gem 'pg', '~> 0.20'
# gem 'thin'
gem 'puma'
gem 'pry'
gem 'simple_form'
gem 'pundit'
gem 'high_voltage'
gem 'nokogiri'
gem 'domainatrix'
gem 'sanitize'
gem 'fastimage'
gem 'mail', '~>2.6.3'
gem 'figaro'
gem 'sendgrid-ruby'

gem 'delayed_job_active_record'
gem 'social-share-button', '~> 1.1.0'
gem 'awesome_print', :require => 'ap'
gem 'google-webfonts'
gem 'ahoy_matey', '~> 1.5.5'
gem 'unirest'
gem 'json'

# gem 'ransack' #http://railscasts.com/episodes/370-ransack
#due to upgrade to 4.2.0 - some changes here....
group :development do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_21]
  gem 'hub', :require=>nil
  gem 'quiet_assets'
  gem 'rails_layout'
  gem 'railroady'
  gem 'bundler-updater'  # run bundler-updater on the command line individually approve each gem needing update
  # gem 'bullet'  # detects n+1 queries
  #This will create an ERD diagram from your database
  gem "rails-erd"

  # test new viewing database option
  gem 'rails_db'
  # added to create seed file
  gem 'seed_dump'
end
