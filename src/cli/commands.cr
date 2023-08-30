# container class
require "../library/classes/container.cr"
require "../library/classes/template.cr"

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
    template : Template = @validate.has_template(args) ? @validate.valid_template(args[2], @admiractl.template_list) : @admiractl._get_default_template

    # set name to lowercase
    args[0] = args[0].downcase

    # Exit if the container already exists
    _cant_exist(args[0])

    # Otherwise, create the container
    puts "Creating container #{args[0]}..."
    result = @admiractl.create(args[0], template)

    # Print the result to the user
    _print_result(result, args[0], "created", "create")
  end

  def delete(args : Array(String))
    # Exit if invalid
    @validate.valid_name(args, "delete")

    # Check and exit if the container does not exist
    _must_exist(args[0])

    # Otherwise, delete the container
    puts "Deleting container #{args[0]}..."
    result = @admiractl.delete(args[0])

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

    # Otherwise, stop the container
    puts "Entering container #{args[0]}..."
    return @admiractl.enter(args[0])
  end

  def help
    puts HELP
  end

  def list
    @terminal_table.list_containers(@admiractl.list)
  end

  def restart(args : Array(String))
    # Exit if invalid
    @validate.valid_name(args, "restart")

    # Check and exit if the container does not exist
    _must_exist(args[0])

    # Otherwise, restart the container
    puts "Restarting container #{args[0]}..."

    # Only first stop the container if it is still running
    if @container.as(Container).state == "running"
      result = @admiractl.stop(args[0])

      # Error if the stop procedure didn't work
      if (result != 1)
        _print_result(result, args[0], "restarted", "restart")
      end
    end

    result = @admiractl.start(args[0])

    # Print the result to the user
    _print_result(result, args[0], "restarted", "restart")
  end

  def set(args : Array(String))
    # Exit if invalid
    @validate.valid_name(args, "set")

    # Exit if the container does not exist
    _must_exist(args[0])

    # Get valid resources, or exit if invalid
    resources = @validate.set(args)

    # Set the resources
    puts "Updating resources on container #{args[0]}..."
    @admiractl.set(@container.as(Container), resources)
    puts "Resources updated successfully"

    # TODO
    # Print the specific errors for each resource, when its the case
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

    # Otherwise, start the container
    puts "Starting container #{args[0]}..."
    result = @admiractl.start(args[0])

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

    # Otherwise, stop the container
    puts "Stopping container #{args[0]}..."
    result = @admiractl.stop(args[0])

    # Print the result to the user
    _print_result(result, args[0], "stopped", "stop")
  end

  def template(args : Array(String))
    if args.size == 0
      @terminal_table.list_templates(@admiractl.template_list)
      exit
    end

    arg = args[0]

    case arg
    when "list"
      @terminal_table.list_templates(@admiractl.template_list)
    else
      puts "Invalid option: #{arg} for \"admiractl template\" command"
    end
  end

  def version
    puts "admiractl version #{VERSION}"
  end

  # reusable methods

  def _cant_exist(name : String)
    container = @admiractl.exists(name)

    if container != nil
      puts "Container #{name} already exists"
      exit
    end
  end

  def _must_exist(name : String)
    container = @admiractl.exists(name)

    if container == nil
      puts "Container #{name} does not exist"
      exit
    end

    @container = container
  end

  def _print_result(result : Bool, name : String, action : String, action2 : String)
    puts result ? "Container #{name} #{action} successfully" : "An error occurred while attempting to #{action2} the container #{name}"
    exit
  end
end
