class Resources
  property cpus : String | Nil
  property disk : String | Nil
  property ram : String | Nil
  property hostname : String | Nil
  property swap : String | Nil

  def initialize(@cpus = nil, @disk = nil, @ram = nil, @hostname = nil, @swap = nil)
  end
end
