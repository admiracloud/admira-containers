require "../library/classes/resources.cr"
require "../library/classes/template.cr"

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
      when "--swap"
        @resources.swap = valid_number(args, index, arg, true)
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
      puts "Missing value for #{resource}. Ex: admiractl set #{args[0]} #{resource} #{example_number}"
      exit
    end

    number = args[index + 1]
    unit = number[-1]

    if number == "0"
      return number
    end

    if has_unit && !(unit == 'M' || unit == 'G')
      puts "Missing or wrong unit (use M or G) on: #{resource} #{number}"
      exit
    end

    if has_unit && !number_regex(number[0..-2])
      puts "Missing or wrong positive integer number on: #{resource} #{number}"
      exit
    end

    if !has_unit && resource == "--cpus"
      # validate cpus passed
      valid_cpus(number)
    end

    return number
  end

  def valid_cpus(cpus : String)
    raw_cpus = `lscpu -p`

    if !$?.success?
      puts "Can't verify the number of total cores on host through 'lscpu'"
      exit
    end

    # lines create an array with each line as elements
    # pop gets the last element (the last line with the higher cpu number on the list)
    # split the last line to an array, by using comma as the separator
    # [0].to_i get the first element and convert it to integer
    total_cpus = raw_cpus.lines.pop.split(',')[0].to_i

    cpus_array = cpus.split(',')

    cpus_array.each do |cpu|
      # split in case of a range, oherwise the array will be of size 1
      range = cpu.split('-')

      # if there are more than two elements, stop here
      if range.size > 2
        puts "Invalid range of cpus: #{cpu}"
        exit
      end

      # ensure each cpu reference to be a positive number and not greater than the max number of cpus available
      range.each do |cpu_number|
        if !number_regex(cpu_number) || cpu_number.to_i < 0 || cpu_number.to_i > total_cpus
          puts "Invalid cpu number: #{cpu_number}"
          exit
        end
      end
    end
  end

  def has_template(args : Array(String)) : Bool
    return false if args.size == 1

    case args[1]
    when "--template"
      if args.size != 3
        puts "Expecting a template name for: admiractl create #{args[0]} --template <name>"
        exit
      end

      return true
    else
      puts "Invalid option #{args[1]} for \"admiractl create\""
      exit
    end
  end

  def valid_template(template : String, templates : Hash(String, Template)) : Template
    if templates.has_key?(template)
      return templates[template]
    end

    puts "Can't find template #{template}"
    exit
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
