source 'http://rubygems.org'

gem 'rack', '~> 1.4.1'
gem 'rack-cors', '~> 0.2.8'
gem 'grape', '~> 0.8.0'
gem 'json'
gem 'mongoid', '~> 4.0.0'
gem 'mongoid-rspec', '~> 2.0.0.rc1'
gem 'bcrypt'

group :development do
  gem 'rake'
  gem 'guard'
  gem 'guard-bundler', '~> 1.0'
  gem 'guard-rspec'
  gem 'rubocop', '0.24.1'
  gem 'rubocop-rspec'
  gem 'reek'
  gem 'yard'
end

group :test do
  gem 'rspec'
  gem 'rack-test', '~> 0.6.2'
  gem 'simplecov', require: false
end

group :test, :development do
  gem 'byebug'
  gem 'did_you_mean', '~> 0.9'
end
