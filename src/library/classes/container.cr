class Container
  property name : String
  property state : String
  property loadavg : String

  def initialize(@name : String, @state : String = "", @loadavg : String = "")
  end
end
