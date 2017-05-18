source 'https://rubygems.org'
ruby "2.3.1"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'

#Common Gems
gem 'rails', '5.0.0'
gem 'pg'
gem 'nokogiri'
gem 'httparty'
gem 'typhoeus'
gem 'will_paginate', '~> 3.1.0'
gem 'zuora_api', '~> 1.3.3'
gem 'zuora_connect', '~> 1.4.4'
gem "delayed_job"
gem "delayed_job_active_record"
gem "daemons"
gem 'lograge'

group :production do
  gem 'unicorn'
  gem 'unicorn-worker-killer'
end

group :development do
  gem 'web-console', '~> 2.0'
  gem "letter_opener"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'byebug'
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', '~> 0.4.0', group: :doc
end

#Front End Gems
group :web do
  gem 'groupdate'
  gem 'chartkick'
  gem "select2-rails"
  gem 'jquery-datatables-rails', :git =>'https://github.com/rweng/jquery-datatables-rails.git'
  gem "delayed_job_web"
  gem 'sinatra', '2.0.0.beta2'
  # Use SCSS for stylesheets
  gem 'sass-rails', '~> 5.0'
  gem 'bootstrap-sass'
  gem 'bootstrap-toggle-rails'
  # Use Uglifier as compressor for JavaScript assets
  gem 'uglifier', '>= 1.3.0'
  # Use CoffeeScript for .coffee assets and views
  gem 'coffee-rails', '~> 4.1.0'
  # See https://github.com/rails/execjs#readme for more supported runtimes
  gem 'therubyracer', platforms: :ruby
  # Use jquery as the JavaScript library
  gem 'jquery-rails'
  gem 'jquery-ui-rails'
  gem 'jquery-migrate-rails'
  gem 'underscore-rails'
  # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
  gem 'jbuilder', '~> 2.0'
  gem 'rubyzip'
  gem 'remotipart', :git => 'https://github.com/JangoSteve/remotipart.git'
end
