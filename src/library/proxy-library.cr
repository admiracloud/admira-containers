class ProxyLibrary
  property config_path : String
  property config_dir : String

  def initialize(@config_path : String, @config_dir : String = "proxies")
    Dir.mkdir_p("#{@config_path}/#{@config_dir}", mode: 0o700) if !File.directory?("#{@config_path}/#{@config_dir}")
  end
end
