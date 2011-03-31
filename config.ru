ROOT = File.expand_path(File.dirname(__FILE__))

# ready to server them files
file_server = Rack::File.new(ROOT)

# wrap it up in a little app
app = proc do |env|
  path = env["PATH_INFO"]

  # if we are looking at / lets try index.html
  if path == "/" && File.exist?(File.join(ROOT,"index.html"))
    env["PATH_INFO"] = "/index.html"
  end
  
  file_server.call(env)
end

run app
