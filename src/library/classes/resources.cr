class Resources
  property cpus : String | Nil
  property disk : String | Nil
  property ram : String | Nil
  property swap : String | Nil
  property hostname : String | Nil
  property name : String | Nil
  property ip : String | Nil
  property autostart : String | Nil

  def initialize(
    @cpus = nil,
    @disk = nil,
    @ram = nil,
    @swap = nil,
    @hostname = nil,
    @name = nil,
    @ip = nil,
    @autostart = nil
  )
  end
end
