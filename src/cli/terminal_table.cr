require "../library/classes/container.cr"

struct TerminalTable
  def list_containers(list : Array(Container))
    length_name : Int32 = 0
    length_state : Int32 = 0
    spacing = 4

    # first, search for the bigger string on each column
    list.each do |container|
      length_name = container.name.size if container.name.size > length_name
      length_state = container.state.size if container.state.size > length_state
    end

    # Add the spacing to the bigger length found on each column
    length_name += spacing
    length_state += spacing

    # Add the missing spacing to the table header
    header_name = "NAME".ljust(length_name)
    header_state = "STATE".ljust(length_state)

    puts "#{header_name} #{header_state}"

    # Then, print the table
    list.each do |container|
      puts "#{container.name.ljust(length_name)} #{container.state.ljust(length_state)}"
    end
  end
end
