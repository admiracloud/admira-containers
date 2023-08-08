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

    # Otherwise
    puts "Creating container #{args[0]}..."
    if @admiractl.create(args)
      # In case of success
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
