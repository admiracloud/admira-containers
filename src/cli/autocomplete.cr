# import admiractl container library
require "../library/admiractl.cr"

struct Autocomplete
  @main = ["create", "delete", "enter", "list", "set", "start", "stop", "restart", "template"]
  @name_commands = ["delete", "enter", "set", "start", "stop", "restart"]
  @template_commands = ["template"]

  def run(args : Array(String))
    # with no arguments, return "main" commands
    if args.size < 2
      puts @main.join("\n")
      exit
    end

    command = args.pop
    value = args.shift

    # identify the "main" command
    if command == "admiractl"
      @main.reject! { |c| !c.starts_with?(value) }
      puts @main.join("\n")
      exit
    end

    # name commands expect a container name, so lets autocomplete
    # with existing container names which starts with the passed value
    if value.size > 0 && @name_commands.index(command) != nil
      list = Admiractl.new.list

      # exit if no container is received
      exit if list.size == 0

      # otherwise, do the match
      match = [] of String
      list.each do |container|
        match << container.name
      end

      match.reject! { |c| !c.starts_with?(value) }
      puts match.join("\n")
      exit
    end

    # teplate commands
    if @template_commands.index(command) != nil
      puts "list"
      exit
    end
  end
end
