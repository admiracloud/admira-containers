require "../library/classes/resources.cr"

struct Validate
  @resources = Resources.new

  def name_regex(name : String)
    name =~ /^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$/
  end

  def number_regex(number : String)
    number =~ /^\d+$/
  end

  def username_regex(username : String)
    username =~ /^[a-z][-a-z0-9]*\$/
  end

  def set(args : Array(String)) : Resources
    index = 1
    size = args.size

    if size == 1
      puts "Missing resource argument. Ex: admiractl set #{args[0]} --ram 2G"
      exit
    end

    while index < size
      arg = args[index]

      case arg
      when "--cpus"
        @resources.cpus = valid_number(args, index, arg, false)
      when "--disk"
        @resources.disk = valid_number(args, index, arg, true)
      when "--ram"
        @resources.ram = valid_number(args, index, arg, true)
      when "--hostname"
        @resources.hostname = valid_hostname(args, index)
        # when "--user"
        #  valid_user(args, index)
      else
        puts "Invalid argument #{arg}"
        exit
      end

      index += 2
    end

    return @resources
  end

  def valid_name(args : Array(String), command : String)
    if args.size == 0
      puts "Missing container name for: admiractl #{command} <name>"
      exit
    end

    if name_regex(args[0]) == nil
      puts "Invalid name for: admiractl #{command} <name>: #{args[0]}"
      exit
    end
  end

  def valid_hostname(args : Array(String), index : Int32) : String
    if args.size <= index + 1
      puts "Missing hostname for --hostname <hostname>"
      exit
    end

    hostname = args[index + 1]

    if name_regex(hostname) == nil
      puts "Invalid hostname for: --hostname #{hostname}"
      exit
    end

    return hostname
  end

  def valid_number(args : Array(String), index : Int32, resource : String, has_unit : Bool) : String
    example_number = has_unit ? "2G" : "2"

    if args.size <= index + 1
      puts "Missing quantity argument for #{resource}. Ex: admiractl set #{args[0]} #{resource} #{example_number}"
      exit
    end

    number = args[index + 1]
    unit = number[-1]

    if has_unit && !(unit == 'M' || unit == 'G')
      puts "Missing or wrong unit (use M or G) on: #{resource} #{number}"
      exit
    end

    if has_unit && !number_regex(number[0..-2])
      puts "Missing or wrong positive integer number on: #{resource} #{number}"
      exit
    end

    if !has_unit && !number_regex(number)
      puts "Use only positive integers on: #{resource}"
      exit
    end

    return number
  end

  # def valid_user(args : Array(String), index : Int32)
  #   if args.size < 3
  #     puts "Missing username for --user <username>"
  #     exit
  #   end

  #   if username_regex(args[2]) == nil
  #     puts "Invalid username for: --user #{args[2]}"
  #     exit
  #   end

  #   if args.size > 3 && args[3] != "--password"
  # end
end
