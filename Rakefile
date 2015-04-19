$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'config'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rake'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'
require 'reek/rake/task'
require './lib/main.rb'

RuboCop::RakeTask.new(:rubocop)
RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = false
end
Reek::Rake::Task.new(:reek)

desc 'API Routes'
task :routes do
  Main::API.routes.each do |api|
    method = api.route_method.ljust(10)
    path = api.route_path
    puts "     #{method} #{path}"
  end
end

task default: [:spec, :rubocop, :reek]
