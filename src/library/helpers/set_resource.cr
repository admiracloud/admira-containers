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
  property resources_list : Array(String) = [
    "lxc.cgroup2.cpuset.cpus",
    "lxc.cgroup2.memory.max",
    "lxc.cgroup2.memory.high",
    "lxc.cgroup2.memory.swap.max",
    "lxc.cgroup2.memory.swap.high",
    "lxc.uts.name",
    "lxc.net.0.ipv4.address",
    "lxc.net.0.ipv4.gateway",
    "lxc.start.auto",
  ]

  # number of lines on config file
  @line_number : Int32 = -1

  def initialize(@container : Container, @resources : Resources)
    # populate the resource hash
    @resources_list.each do |resource|
      @indexes[resource] = {"line" => -1, "value" => ""}
    end

    # read the config file
    raw = File.read("/var/lib/lxc/#{@container.name}/config")

    # update the resource hash with the passed resources
    raw.each_line do |line|
      @line_number += 1
      config << line

      @resources_list.each do |resource|
        next if !line.starts_with?(resource)

        @indexes[resource] = {"line" => @line_number, "value" => line.split("=")[1..].join("=").strip}

        # save the last line where there are resources in the config file
        # to know where to add new lines, when its the case
        @last_resource_line = @line_number

        # if a specific resource where found on a line, stop looking for other resources on the same line
        break
      end
    end

    # when no resources were already being added, add a new section for it
    create_resource_section if @last_resource_line == -1 && config.index("# Hardware configuration") != nil

    # update the resources live and on config
    update_resources()

    # save the updated config on disk
    save()
  end

  def create_resource_section
    config << ""
    config << "# Hardware configuration"
    config << ""
    @last_resource_line = @line_number + 3
  end

  def update_resources
    # ram
    if @resources.ram != nil
      ram("high")
      ram("max")
    end

    # cpu
    if @resources.cpus != nil
      cpus()
    end

    # swap
    if @resources.swap != nil
      ram("swap.high")
      ram("swap.max")
    end

    # hostname
    if @resources.hostname != nil
      hostname()
    end

    # new name
    if @resources.name != nil
      name()
    end

    # new name
    if @resources.ip != nil
      ip()
    end

    # autostart
    if @resources.autostart != nil
      autostart()
    end
  end

  def save
    File.write("/var/lib/lxc/#{@container.name}/config", @config.join("\n"), mode: "w+")
  end

  def cpus
    # update the container if its running
    if @container.state == "running"
      `lxc-cgroup -n #{@container.name} cpuset.cpus #{@resources.cpus}`

      if !$?.success?
        puts "Error while trying to set the cpus for #{@container.name} to #{@resources.cpus}"
        exit
      end
    end

    update_config("lxc.cgroup2.cpuset.cpus", @resources.cpus)
  end

  def hostname
    # update the container if its running
    if @container.state == "running"
      `lxc-execute -n #{@container.name} -- hostname #{@resources.hostname}`

      if !$?.success?
        puts "Error while trying to set hostname for #{@container.name} to #{@resources.hostname}"
        exit
      end
    end

    update_config("lxc.uts.name", @resources.hostname)
  end

  def name
    # container's name cannot be updated if its running
    if @container.state == "running"
      puts "Container #{@container.name} is running. Cannot change it's name to #{@resources.name}"
      exit
    end

    # in LXC, to change a container's name, you should rename its original folder on /var/lib/lxc/<container-name>
    `mv /var/lib/lxc/#{@container.name} /var/lib/lxc/#{@resources.name}`

    if !$?.success?
      puts "Error while trying to rename #{@container.name} to #{@resources.name}"
      exit
    end

    # change the name also internally, to ensure the config file to be saved correctly
    @container.name = @resources.name.as(String)
  end

  def ram(level : String)
    value : String = level.starts_with?("swap") ? @resources.swap.as(String) : @resources.ram.as(String)

    # update the container if its running
    if @container.state == "running"
      `lxc-cgroup -n #{@container.name} memory.#{level} #{value}`
    end

    update_config("lxc.cgroup2.memory.#{level}", value)
  end

  def autostart
    autostart = @resources.autostart == "yes" ? "1" : "0"
    update_config("lxc.start.auto", autostart)
  end

  def ip
    if @container.state == "running"
      puts "The new IP #{@resources.ip} will only be applied after the container '#{@container.name}' is restarted"
    end

    update_config("lxc.net.0.ipv4.address", @resources.ip)

    # calculate the gateway

    # remove optional cidr and split ip by its dots
    ip_array = @resources.ip.as(String).split("/")[0].split(".")
    ip_array[3] = "1"
    gateway = ip_array.join(".")

    update_config("lxc.net.0.ipv4.gateway", gateway)
  end

  def update_config(config_line : String, value : String | Nil)
    # add or update the config file
    index = @indexes[config_line]

    if index["value"] != value
      complete_line_content = "#{config_line} = #{value}"

      if index["line"] == -1
        @config.insert(@last_resource_line, complete_line_content)
        @last_resource_line += 1
      else
        @config[index["line"].as(Int32)] = complete_line_content
      end
    end
  end

  # def ip
  # dhclient -r eth0 && dhclient eth0
  # networkctl renew eth0
  # end
end
