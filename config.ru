ROOT = File.expand_path(File.dirname(__FILE__))

# ready to server them files
file_server = Rack::File.new(ROOT)

# prohibit showing system files
FORBIDDEN = %w( /.git /.gitignore /config.ru )

# wrap it up in a little app
app = proc do |env|
  path = env["PATH_INFO"]
  
  if FORBIDDEN.any?{|forbidden_path| path.start_with?(forbidden_path)}
    return [403, {"Content-Type" => "text/plain"}, "This path is forbidden"]
  end

  # if we are looking at / lets try index.html
  if path == "/" && File.exist?(File.join(ROOT,"index.html"))
    env["PATH_INFO"] = "/index.html"
  end
  
  file_server.call(env)
end

run app
