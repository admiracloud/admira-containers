# container class
require "../library/classes/container.cr"

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

  # container reference
  @container : (Container | Nil)

  def create(args : Array(String))
    # Exit if invalid
    @validate.valid_name(args, "create")

    # set name to lowercase
    args[0] = args[0].downcase

    # Check and exit if the container already exists
    _cant_exist(args[0])

    # Otherwise, create the container, avoiding another check with "false"
    puts "Creating container #{args[0]}..."
    result = @admiractl.create(args, false)

    # Print the result to the user
    _print_result(result, args[0], "created", "create")
  end

  def delete(args : Array(String))
    # Exit if invalid
    @validate.valid_name(args, "delete")

    # Check and exit if the container does not exist
    _must_exist(args[0])

    # Otherwise, delete the container, avoiding another check with "false"
    puts "Deleting container #{args[0]}..."
    result = @admiractl.delete(args, false)

    # Print the result to the user
    _print_result(result, args[0], "deleted", "delete")
  end

  def enter(args : Array(String))
    # Exit if invalid
    @validate.valid_name(args, "enter")

    # Check and exit if the container does not exist
    _must_exist(args[0])

    # If not running, informs the user and do nothing
    if @container.as(Container).state != "running"
      puts "Container #{args[0]} is not running"
      exit
    end

    # Otherwise, stop the container, avoiding another check with "false"
    puts "Entering container #{args[0]}..."
    return @admiractl.enter(args[0])
  end

  def help
    puts HELP
  end

  def list
    @terminal_table.list_containers(@admiractl.list)
  end

  def start(args : Array(String))
    # Exit if invalid
    @validate.valid_name(args, "start")

    # Check and exit if the container does not exist
    _must_exist(args[0])

    # If already started, informs the user and do nothing
    if @container.as(Container).state == "running"
      puts "Container #{args[0]} already running"
      exit
    end

    # Otherwise, start the container, avoiding another check with "false"
    puts "Starting container #{args[0]}..."
    result = @admiractl.start(args, false)

    # Print the result to the user
    _print_result(result, args[0], "started", "start")
  end

  def stop(args : Array(String))
    # Exit if invalid
    @validate.valid_name(args, "stop")

    # Check and exit if the container does not exist
    _must_exist(args[0])

    # If already stopped, informs the user and do nothing
    if @container.as(Container).state == "stopped"
      puts "Container #{args[0]} already stopped"
      exit
    end

    # Otherwise, stop the container, avoiding another check with "false"
    puts "Stopping container #{args[0]}..."
    result = @admiractl.stop(args, false)

    # Print the result to the user
    _print_result(result, args[0], "stopped", "stop")
  end

  def restart(args : Array(String))
    # Exit if invalid
    @validate.valid_name(args, "restart")

    # Check and exit if the container does not exist
    _must_exist(args[0])

    # Otherwise, restart the container, avoiding another check with "false"
    puts "Restarting container #{args[0]}..."

    # Only first stop the container if it is still running
    if @container.as(Container).state == "running"
      result = @admiractl.stop(args, false)

      # Error if the stop procedure doesn't worked
      if (result != 1)
        _print_result(result, args[0], "restarted", "restart")
      end
    end

    result = @admiractl.start(args, false)

    # Print the result to the user
    _print_result(result, args[0], "restarted", "restart")
  end

  def version
    puts "admiractl version #{VERSION}"
  end

  # reusable methods

  def _cant_exist(name : String)
    container = @admiractl.exists(name)

    if typeof(container) == Container
      puts "Container #{name} already exists"
      exit
    end
  end

  def _must_exist(name : String)
    container = @admiractl.exists(name)

    if typeof(container) == Nil
      puts "Container #{name} does not exist"
      exit
    end

    @container = container
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
