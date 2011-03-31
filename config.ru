# ensure we use etags
use ::Rack::ConditionalGet
use ::Rack::ETag

# wrap it up in a little app
class ServeThis

  def initialize(root)
    @root = root
    @file_server = ::Rack::File.new(root)
  end
  attr_reader :root, :file_server

  def call(env)
    path = env["PATH_INFO"]
    
    if forbid?(path)
      forbid!
    else

      # if we are looking at / lets try index.html
      if path == "/" && File.exist?(File.join(self.root,"index.html"))
        env["PATH_INFO"] = "/index.html"
      end
  
      self.file_server.call(env)
    end
  end
  
  # prohibit showing system files
  FORBIDDEN = %w( /.git /.gitignore /config.ru )

  def forbid?(path)
    FORBIDDEN.any? do |forbidden_path|
      path.start_with?(forbidden_path)
    end
  end
  
  def forbid!
    body = "Forbidden\n"
    size = Rack::Utils.bytesize(body)
    return [403, {"Content-Type" => "text/plain",
      "Content-Length" => size.to_s,
      "X-Cascade" => "pass"}, [body]]
  end
  
end

app = ServeThis.new(Dir.pwd)

run app
