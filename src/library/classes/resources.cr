class Resources
  property cpus : String | Nil
  property disk : String | Nil
  property ram : String | Nil
  property hostname : String | Nil

  def initialize(@cpus : String | Nil = nil, @disk : String | Nil = nil, @ram : String | Nil = nil, @hostname : String | Nil = nil)
  end
end
