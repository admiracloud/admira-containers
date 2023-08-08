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

  #
  def create(args : Array(String))
    # Exit if invalid
    @validate.create(args)

    # Proactively check if the container already exists
    if @admiractl.exists(args[0])
      puts "Container #{args[0]} already exists"
      exit
    end

    # Otherwise, start the creation avoiding to check again if a container with
    # the same name already exists, using "false" on the seccond argument of
    # @admiractl.create method
    puts "Creating container #{args[0]}..."
    result = @admiractl.create(args, false)

    # Print the result to the user
    case result
    when 1
      puts "Container #{args[0]} created successfully"
    else
      puts "An error occurred while attempting to create the container #{args[0]}"
    end

    exit
  end

  def help
    puts HELP
  end

  def version
    puts "admiractl version #{VERSION}"
  end

  #
  def list
    @terminal_table.list_containers(@admiractl.list)
  end
end
