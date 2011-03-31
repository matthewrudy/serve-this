module ServeThis

  def self.from(root)
    Rack::Builder.new do
      # ensure we use etags
      use ::Rack::ConditionalGet
      use ::Rack::ETag
      
      # we respond to HEAD requests
      use ::Rack::Head
      
      app = ServeThis::App.new(root)
      run app
    end.to_app
  end
  
  # this does the file serving
  class App
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
        if path == "/" && exists?("index.html")
          env["PATH_INFO"] = "/index.html"
        end
  
        self.file_server.call(env)
      end
    end
    
    def exists?(path)
      File.exist?(File.join(self.root, path))
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
  
end