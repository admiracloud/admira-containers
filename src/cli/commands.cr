# validation and help messages
require "./validate.cr"
require "./help.cr"

# styling
require "./terminal_table.cr"

# import admiractl container library
require "../library/admiractl.cr"

struct Commands
  # libraries
  @validate = Validate.new
  @admiractl = Admiractl.new
  @terminal_table = TerminalTable.new

  def create(args : Array(String))
    # Exit if invalid
    @validate.create(args)

    # Check and exit if the container already exists
    _exists(args[0])

    # Otherwise, create the container, avoiding another check with "false"
    puts "Creating container #{args[0]}..."
    result = @admiractl.create(args, false)

    # Print the result to the user
    _print_result(result, args[0], "created", "create")
  end

  def delete(args : Array(String))
    # Exit if invalid
    @validate.delete(args)

    # Check and exit if the container does not exist
    _doesnt_exist(args[0])

    # Otherwise, delete the container, avoiding another check with "false"
    puts "Deleting container #{args[0]}..."
    result = @admiractl.delete(args, false)

    # Print the result to the user
    _print_result(result, args[0], "deleted", "delete")
  end

  def help
    puts HELP
  end

  def list
    @terminal_table.list_containers(@admiractl.list)
  end

  def start(args : Array(String))
    # Exit if invalid
    @validate.start(args)

    # Check and exit if the container does not exist
    _doesnt_exist(args[0])

    # Otherwise, start the container, avoiding another check with "false"
    puts "Starting container #{args[0]}..."
    result = @admiractl.start(args, false)

    # Print the result to the user
    _print_result(result, args[0], "started", "start")
  end

  def stop(args : Array(String))
    # Exit if invalid
    @validate.stop(args)

    # Check and exit if the container does not exist
    _doesnt_exist(args[0])

    # Otherwise, stop the container, avoiding another check with "false"
    puts "Stopping container #{args[0]}..."
    result = @admiractl.stop(args, false)

    # Print the result to the user
    _print_result(result, args[0], "stopped", "stop")
  end

  def restart(args : Array(String))
    # Exit if invalid
    @validate.restart(args)

    # Check and exit if the container does not exist
    _doesnt_exist(args[0])

    # Otherwise, restart the container, avoiding another check with "false"
    puts "Reastarting container #{args[0]}..."
    result = @admiractl.stop(args, false)

    # Error if the stop procedure doesn't worked
    if (result != 1)
      _print_result(result, args[0], "restarted", "restart")
    end

    result = @admiractl.start(args, false)

    # Print the result to the user
    _print_result(result, args[0], "restarted", "restart")
  end

  def version
    puts "admiractl version #{VERSION}"
  end

  # reusable methods

  def _exists(name : String)
    if @admiractl.exists(name)
      puts "Container #{name} already exists"
      exit
    end
  end

  def _doesnt_exist(name : String)
    if !@admiractl.exists(name)
      puts "Container #{name} does not exist"
      exit
    end
  end

  def _print_result(result : Int32, name : String, action : String, action2 : String)
    case result
    when 1
      puts "Container #{name} #{action} successfully"
    else
      puts "An error occurred while attempting to #{action2} the container #{name}"
    end
    exit
  end
end
