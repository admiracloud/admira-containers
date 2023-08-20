# helpers with methods to to the heavy lifting,
# like transforming a raw command output into an
# array of container instances
require "./helpers/helpers.cr"

# organized "set" methods, like set ram and cpus
require "./helpers/set.cr"

require "./classes/result.cr"

struct Admiractl
  # Helpers methods
  @helpers = Helpers.new
  @config_path = "/etc/admiractl"
  @template_cache = "templates.json"

  def initialize(@config_path : String = "/etc/admiractl")
    if !File.directory?(@config_path)
      Dir.mkdir_p(@config_path, mode: 700)
    end
  end

  # return codes
  # 1  : container created
  # 0  : container already exists
  # -1 : external error
  def create(args : Array(String), check_exists : Bool = true) : Int32
    args[0] = args[0].downcase

    return 0 if check_exists && exists(args[0])

    `lxc-create -n #{args[0]} --template debian-12-download --quiet`
    return $?.success? ? 1 : -1
  end

  # return codes
  # 1  : container deleted
  # 0  : container does not exist
  # -1 : external error
  def delete(args : Array(String), check_not_exists : Bool = true) : Int32
    return 0 if check_not_exists && !exists(args[0])

    `lxc-destroy -n #{args[0]} --quiet`
    return $?.success? ? 1 : -1
  end

  def enter(name : String)
    # return `lxc-attach #{name}`
    return Process.exec("lxc-attach", args: [name], shell: false)
  end

  # return types
  # Container instance : container exists
  # Nil                : container does not exist
  def exists(name : String)
    container_list = list
    container_list.each do |container|
      return container if container.name == name
    end

    return nil
  end

  # return an array of containers: Array(Containers)
  # the container type is defined on: /src/library/classes/container.cr
  def list
    raw = `lxc-ls -f -F NAME,STATE,PID,RAM,SWAP,AUTOSTART,GROUPS,INTERFACE,IPV4,IPV6,UNPRIVILEGED`
    return @helpers.container_list(raw)
  end

  def set(container : Container, resources : Resources)
    set = SetResource.new(container, resources)
  end

  # return codes
  # 1  : container started
  # 0  : container does not exist
  # -1 : external error
  def start(args : Array(String), check_not_exists : Bool = true) : Int32
    return 0 if check_not_exists && !exists(args[0])

    `lxc-start -n #{args[0]} --quiet`
    return $?.success? ? 1 : -1
  end

  # return codes
  # 1  : container stop
  # 0  : container does not exist
  # -1 : external error
  def stop(args : Array(String), check_not_exists : Bool = true) : Int32
    return 0 if check_not_exists && !exists(args[0])

    `lxc-stop -n #{args[0]} --quiet`
    return $?.success? ? 1 : -1
  end

  #
  def template_list
    return @helpers.template_list("#{@config_path}/#{@template_cache}")
  end
end
