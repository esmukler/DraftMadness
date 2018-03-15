source 'http://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0'
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails'
gem 'bootstrap-sass', '~> 3.3.6'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# authentication
gem 'devise', '~> 4.1.0'
gem 'devise_invitable'

gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'omniauth-facebook', '~> 4.0'

gem 'react-rails', '~> 1.6.0'
gem 'browserify-rails'

gem 'simple_form'

# SMS messaging
gem 'twilio-ruby'

# run tasks
gem 'thor'

gem 'rest-client'

group :production do
  gem 'rails_12factor'

  # better server
  gem 'puma'

  gem 'memcachier'
  # caching
  gem 'dalli'

  gem 'connection_pool'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry-rails'
  gem 'awesome_print'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'factory_girl_rails'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
end

group :test do
  gem 'rspec-rails'
  gem 'rails-controller-testing'
end
