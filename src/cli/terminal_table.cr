require "../library/classes/container.cr"
require "../library/classes/template.cr"

struct TerminalTable
  def list_containers(list : Array(Container))
    length_name : Int32 = 4  # "NAME" length
    length_state : Int32 = 5 # "STATE" length
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

  def list_templates(list : Hash(String, Template))
    length_distribution : Int32 = 12 # "DISTRIBUTION" length
    length_version : Int32 = 7       # "VERSION" length
    length_architecture : Int32 = 12 # "ARCHITECTURE" length
    length_shortname : Int32 = 9     # "SHORTNAME" length
    spacing = 4

    # first, search for the bigger string on each column
    list.each do |shortname, template|
      length_distribution = template.distribution.size if template.distribution.size > length_distribution
      length_version = template.version.size if template.version.size > length_version
      length_architecture = template.architecture.size if template.architecture.size > length_architecture
      length_shortname = shortname.size if shortname.size > length_shortname
    end

    # Add the spacing to the bigger length found on each column
    length_distribution += spacing
    length_version += spacing
    length_architecture += spacing
    length_shortname += spacing

    # Add the missing spacing to the table header
    header_distribution = "DISTRIBUTION".ljust(length_distribution)
    header_version = "VERSION".ljust(length_version)
    header_architecture = "ARCHITECTURE".ljust(length_architecture)
    header_shortname = "SHORTNAME".ljust(length_shortname)

    puts "#{header_distribution} #{header_version} #{header_architecture} #{header_shortname}"

    # Then, print the table
    list.each do |shortname, template|
      puts "#{template.distribution.ljust(length_distribution)} #{template.version.ljust(length_version)} #{template.architecture.ljust(length_architecture)} #{shortname.ljust(length_shortname)}"
    end
  end
end
