require "../library/classes/container.cr"
require "../library/classes/template.cr"

struct TerminalTable
  def list_containers(list : Array(Container))
    length = Hash(String, Int32).new
    spacing = 4

    # prepare length hash
    list[0].to_hash.each do |column, value|
      length[column] = column.size
    end

    # search for the bigger string on each column
    list.each do |container_obj|
      container = container_obj.to_hash

      container.each do |column, value|
        length[column] = value.size if value.size > length[column]
      end
    end

    # Add the spacing to the bigger length found on each column
    # Prepare header
    header = [] of String
    length.each do |column, value|
      length[column] += spacing
      header << column.upcase.ljust(length[column])
    end

    # Print header
    puts header.join(" ")

    # Then, print the table
    list.each do |container_obj|
      container = container_obj.to_hash

      line = [] of String
      container.each do |column, value|
        line << value.ljust(length[column])
      end

      puts line.join(" ")
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
