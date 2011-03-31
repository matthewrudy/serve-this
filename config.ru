file_server = ::Rack::File.new(File.dirname(__FILE__))

run file_server
