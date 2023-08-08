struct Validate
  def name(name : String)
    name =~ /^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$/
  end

  def create(args : Array(String))
    if args.size == 0
      puts "Missing name for: admiractl create <name>"
      exit
    end

    if name(args[0]) == nil
      puts "Invalid name for: admiractl create <name>: #{args[0]}"
      exit
    end

    return true
  end

  def is_root
    user = `id -u -n`.strip
    if user != "root"
      puts "admiractl must be run as root. Current user: #{user}"
      exit
    end
  end
end
