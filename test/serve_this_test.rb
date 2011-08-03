require 'test_helper'
require 'serve-this'

class ServeThisTest < ActiveSupport::TestCase
  
  def setup
    @example_dir = File.expand_path("../example", File.dirname(__FILE__))
    @app = ServeThis::App.new(@example_dir)
  end
  
  test "/ -> index.html" do
    resolves_to("/index.html", "/")
  end
  
  test "/index -> index.html" do
    resolves_to("/index.html", "/index")
  end
  
  test "/nofile -> unchanged" do
    resolves_to("/nofile", "/nofile")
  end
  
  test "favicon - bundled if not present" do
    assert !@app.exists?("favicon.ico")
    @app.expects(:file_server).never
    bundled = stub("bundled")
    @app.expects(:res_server).returns(bundled)
    
    bundled.expects(:call).with("PATH_INFO" => "/favicon.ico")
    call("/favicon.ico")
  end
  
  test "favicon - served if there" do
    assert !@app.exists?("favicon.ico")
    begin
      `touch #{@example_dir}/favicon.ico`
      
      assert @app.exists?("favicon.ico")
      resolves_to("/favicon.ico", "/favicon.ico")
    ensure
      `rm #{@example_dir}/favicon.ico`
    end
  end
  
  test "exists? - with the file" do
    assert @app.exists?("index.html")
  end
  
  test "exists? - without the file" do
    assert !@app.exists?("no.html")
  end
  
  test "forbid? - Gemfile" do
    assert @app.exists?("Gemfile")
    assert @app.forbid?("Gemfile")
  end
  
  test "forbid? - Gemfile.lock" do
    assert @app.exists?("Gemfile.lock")
    assert @app.forbid?("Gemfile.lock")
  end
  
  test "forbid? - config.ru" do
    assert @app.exists?("config.ru")
    assert @app.forbid?("config.ru")
  end
  
  test "forbid? - a dot-file" do
    assert !@app.exists?(".secret")
    assert @app.forbid?(".secret")
  end
  
  test "forbid? - a normal file" do
    assert @app.exists?("index.html")
    assert !@app.forbid?("index.html")
  end
  
  test "forbid! - is an http forbidden" do
    assert_equal [
      403,
     {"X-Cascade"=>"pass", "Content-Type"=>"text/plain", "Content-Length"=>"10"},
     ["Forbidden\n"]], @app.forbid!
  end
  
  protected
  
  def call(path)
    @app.call("PATH_INFO" => path)
  end
  
  def resolves_to(file, path)
    file_stub = stub("file server")
    @app.expects(:file_server).returns(file_stub)
    file_stub.expects(:call).with("PATH_INFO" => file)
    
    call(path)
  end
  
end
  