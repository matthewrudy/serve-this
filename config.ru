ROOT = File.expand_path(File.dirname(__FILE__))

# ready to server them files
FILE_SERVER = ::Rack::File.new(ROOT)

# prohibit showing system files
FORBIDDEN = %w( /.git /.gitignore /config.ru )

use ::Rack::ConditionalGet
use ::Rack::ETag

# wrap it up in a little app
class ServeThis

  def forbid!
    body = "Forbidden\n"
    size = Rack::Utils.bytesize(body)
    return [403, {"Content-Type" => "text/plain",
      "Content-Length" => size.to_s,
      "X-Cascade" => "pass"}, [body]]
  end
  
  def forbid?(path)
    FORBIDDEN.any? do |forbidden_path|
      path.start_with?(forbidden_path)
    end
  end
  
  def call(env)
    path = env["PATH_INFO"]
    
    if forbid?(path)
      forbid!
    else

      # if we are looking at / lets try index.html
      if path == "/" && File.exist?(File.join(ROOT,"index.html"))
        env["PATH_INFO"] = "/index.html"
      end
  
      FILE_SERVER.call(env)
    end
  end
end

app = ServeThis.new

run app
