require "json"

class Proxy
  include JSON::Serializable
  property proxy_name : String
  property ip : String
  property extra_domains : Array(String)

  def initialize(@proxy_name : String, @main_domain : String, @ip : String, @extra_domains : Array(String) = [] of String)
  end
end
