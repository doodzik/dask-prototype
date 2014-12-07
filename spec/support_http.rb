$LOAD_PATH.unshift(File.join("#{File.dirname(__FILE__)}/..", 'app'))

require 'support'
require 'rack/test'

ENV['RACK_ENV'] = 'test'
