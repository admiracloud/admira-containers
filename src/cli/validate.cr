struct Validate
  def name_regex(name : String)
    name =~ /^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$/
  end

  def create(args : Array(String))
    if args.size == 0
      puts "Missing name for: admiractl create <name>"
      exit
    end

    if name_regex(args[0]) == nil
      puts "Invalid name for: admiractl create <name>: #{args[0]}"
      exit
    end
  end

  def delete(args : Array(String))
    if args.size == 0
      puts "Missing name for: admiractl delete <name>"
      exit
    end

    if name_regex(args[0]) == nil
      puts "Invalid name for: admiractl delete <name>: #{args[0]}"
      exit
    end
  end
end
