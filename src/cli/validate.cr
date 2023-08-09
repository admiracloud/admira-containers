struct Validate
  def name_regex(name : String)
    name =~ /^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$/
  end

  def valid_name(args : Array(String), command : String)
    if args.size == 0
      puts "Missing name for: admiractl #{command} <name>"
      exit
    end

    if name_regex(args[0]) == nil
      puts "Invalid name for: admiractl #{command} <name>: #{args[0]}"
      exit
    end
  end
end
