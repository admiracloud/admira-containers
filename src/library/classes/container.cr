class Container
  property name : String
  property state : String
  property cpus : String
  property ram : String
  property disk : String
  property loadavg : String
  property ram_usage : String
  property disk_usage : String

  def initialize(
    @name : String,
    @state : String = "",
    @cpus : String = "",
    @ram : String = "",
    @disk : String = "",
    @loadavg : String = "",
    @ram_usage : String = "",
    @disk_usage : String = ""
  )
  end

  def to_hash
    {"name" => @name, "state" => @state, "cpus" => @cpus, "ram" => @ram, "disk" => @disk, "loadavg" => @loadavg, "ram_usage" => @ram_usage, "disk_usage" => @disk_usage}
  end
end
