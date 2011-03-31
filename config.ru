# ensure we use etags
use ::Rack::ConditionalGet
use ::Rack::ETag

require 'lib/serve-this'

# grab our app
app = ServeThis.new(Dir.pwd)

run app
