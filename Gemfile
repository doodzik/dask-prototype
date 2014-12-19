source 'http://rubygems.org'

gem 'rack'
gem 'rack-cors'
gem 'grape'
gem 'mongoid'
gem 'bcrypt'

group :development do
  gem 'rake'
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-rspec'
  gem 'rubocop'
  gem 'rubocop-rspec'
  gem 'reek'
  gem 'yard'
end

group :test do
  gem 'rspec'
  gem 'mongoid-rspec'
  gem 'rack-test'
  gem 'simplecov', require: false
end

group :test, :development do
  gem 'byebug'
  gem 'did_you_mean'
end
