require "../classes/container.cr"
require "../classes/resources.cr"

struct SetResource
  property container : Container
  property resources : Resources
  property errors : Resources = Resources.new
  property config = [] of String

  # indexes to each resource inside the config file
  property indexes = {} of String => Hash(String, String | Int32)

  # line of last resource found
  property last_resource_line : Int32 = -1

  # possible resources
  property resources_list : Array(String) = ["lxc.cgroup2.cpuset.cpus", "lxc.cgroup2.memory.max", "lxc.cgroup2.memory.high"]

  # number of lines on config file
  @line_number : Int32 = -1

  def initialize(@container : Container, @resources : Resources)
    # populate the resource hash
    @resources_list.each do |resource|
      indexes[resource] = {"line" => -1, "value" => ""}
    end

    # read the config file
    raw = File.read("/var/lib/lxc/#{@container.name}/config")

    # update the resource hash with the passed resources
    raw.each_line do |line|
      @line_number += 1
      config << line

      @resources_list.each do |resource|
        next if !line.starts_with?(resource)

        indexes[resource] = {"line" => @line_number, "value" => line.split("=")[1..].join("=").strip}

        # save the last line where there are resources in the config file
        # to know where to add new lines, when its the case
        @last_resource_line = @line_number

        # if a specific resource where found on a line, stop looking for other resources on the same line
        break
      end
    end

    # when no resources were already being added, add a new section for it
    create_resource_section if @last_resource_line == -1

    # update the resources on config
    update

    # save the updated config on disk
    save
  end

  def create_resource_section
    config << ""
    config << "# Hardware configuration"
    config << ""
    @last_resource_line = @line_number + 3
  end

  def update
    # ram
    if resources.ram != nil
      ram("high")
      ram("max")
    end

    # cpu
  end

  def save
    File.write("/var/lib/lxc/#{@container.name}/config", @config.join("\n"), mode: "w+")
  end

  def ram(type : String)
    # update the container if its running
    if @container.state == "running"
      `lxc-cgroup -n #{@container.name} memory.#{type} #{@resources.ram}`
    end

    # add or update the config file
    index = @indexes["lxc.cgroup2.memory.#{type}"]

    if index["value"] != @resources.ram
      complete_line_content = "lxc.cgroup2.memory.#{type} = #{@resources.ram}"

      if index["line"] == -1
        @config.insert(@last_resource_line, complete_line_content)
        @last_resource_line += 1
      else
        @config[index["line"].as(Int32)] = complete_line_content
      end
    end
  end
end
