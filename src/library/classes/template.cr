require "json"

class Template
  include JSON::Serializable
  property distribution : String
  property version : String
  property architecture : String

  def initialize(@distribution : String, @version : String, @architecture : String)
  end
end
