class Container
  property name : String
  property state : String
  property ipv4 : String
  property cpus : String
  property ram : String
  property disk : String
  property loadavg : String
  property ram_usage : String
  property disk_usage : String
  property autostart : String

  def initialize(
    @name : String,
    @state : String = "",
    @ipv4 : String = "",
    @cpus : String = "",
    @ram : String = "",
    @disk : String = "",
    @loadavg : String = "",
    @ram_usage : String = "",
    @disk_usage : String = "",
    @autostart : String = ""
  )
  end

  def to_hash
    {
      "name"       => @name,
      "state"      => @state,
      "ipv4"       => @ipv4,
      "cpus"       => @cpus,
      "ram"        => @ram,
      "disk"       => @disk,
      "loadavg"    => @loadavg,
      "ram_usage"  => @ram_usage,
      "disk_usage" => @disk_usage,
      "autostart"  => @autostart,
    }
  end
end
