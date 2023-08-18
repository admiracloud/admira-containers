class Result
  property success : Bool
  property message : String

  def initialize(@success : Bool = false, @message : String = "")
  end
end
