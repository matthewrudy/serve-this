require 'rack'

module ServeThis
  
  VERSION = "0.0.6"

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
      
      res_path = ::File.join(::File.dirname(__FILE__), "..", "res")
      @res_server  = ::Rack::File.new(::File.expand_path(res_path))
    end
    attr_reader :root, :file_server, :res_server

    def call(env)
      path = env["PATH_INFO"]
    
      if forbid?(path)
        forbid!
      else

        # if we are looking at / lets try index.html
        if path == "/" && exists?("index.html")
          env["PATH_INFO"] = "/index.html"
        elsif path == "/favicon.ico" && !exists?("favicon.ico")
          return self.res_server.call(env)
        elsif !exists?(path) && exists?(path+".html")
          env["PATH_INFO"] += ".html"
        end
        
        self.file_server.call(env)
      end
    end
    
    def exists?(path)
      File.exist?(File.join(self.root, path))
    end
  
    # prohibit showing system files
    FORBIDDEN_REGEXP = /^(\.|config.ru$|Gemfile$|Gemfile.lock$)/i

    def forbid?(path)
      unescaped_path = ::Rack::Utils.unescape(path)
      if unescaped_path.start_with?("/")
        unescaped_path = unescaped_path[1..-1]
      end
      
      unescaped_path =~ FORBIDDEN_REGEXP
    end
    
    def forbid!
      self.file_server.forbidden
    end
  end
  
end