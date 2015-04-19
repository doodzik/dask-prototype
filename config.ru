$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'config'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'mongoid'
require 'grape'
require 'rack/cors'
require 'main' # require api
require 'rack/contrib'

module Mongoid
  # reopens Document
  module Document
    # if document is converted into a json the id is converted to a string
    #   so that the client can use it.
    #   the id field specificly selected for ember-data
    def as_json(options = {})
      attrs = super(options)
      attrs['id'] = attrs['_id'].to_s
      attrs
    end
  end
end

Mongoid.load!('./config/mongoid.yml')

# add cors support
# use Rack::Cors do
#   allow do
#     origins '*'
#     resource '*', headers: :any, methods: [ :get, :post ]
#   end
# end

class App
  def initialize(options)
    @try = ['', *options.delete(:try)]
    @static = ::Rack::Static.new(
      lambda { [404, {}, []] },
      options)
  end

  def call(env)
    orig_path = env['PATH_INFO']
    # there's probably a better way to do this
    if orig_path.starts_with?('/api/')
      Main::API.call(env)
    else
      found = nil
      @try.each do |path|
        resp = @static.call(env.merge!({'PATH_INFO' => orig_path + path}))
        break if 404 != resp[0] && found = resp
      end
      found or [404, {}, []]
    end
  end
end

run App.new({
  :root => File.expand_path('../public', __FILE__),
  :urls => %w[/],
  :try => ['.html', 'index.html', '/index.html']
  })

# use Rack::TryStatic,
#   :root => File.expand_path('../public', __FILE__),
#   :urls => %w[/], :try => ['.html', 'index.html', '/index.html']

# run Main::API
