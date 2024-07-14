# helpers with methods to do the heavy lifting,
# like transforming a raw command output into an
# array of container instances
require "./helpers/helpers.cr"

# organized "set" methods, like set ram and cpus
require "./helpers/set_resource.cr"

# classes
require "./classes/result.cr"
require "./classes/template.cr"

# subcommands
require "./proxy-library.cr"

class Admiractl
  # Helpers methods
  @helpers = Helpers.new
  @config_path = "/etc/admiractl"
  @config_file = "admiractl.conf"
  @template_cache = "templates.json"
  @default_template = Template.new("almalinux", "9", "amd64")

  def initialize
    Dir.mkdir_p(@config_path, mode: 0o700) if !File.directory?(@config_path)

    # Proxy methods
    @proxy = ProxyLibrary.new(@config_path)
  end

  # return codes
  # true  : container created
  # false : container already exists
  def create(name : String, template : Template) : Bool
    name = name.downcase

    template.version = "current" if template.version == ""

    `lxc-create -n #{name} --quiet --template download -- template-options --dist #{template.distribution} --release #{template.version} --arch #{template.architecture}`
    return $?.success?
  end

  # return codes
  # true  : container deleted
  # false : container does not exist
  def delete(name : String) : Bool
    `lxc-destroy -n #{name} --quiet`
    return $?.success?
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
    raw = `lxc-ls -f -F NAME,STATE,PID,RAM,SWAP,AUTOSTART,GROUPS,IPV4,UNPRIVILEGED`
    return @helpers.container_list(raw)
  end

  def set(container : Container, resources : Resources)
    set = SetResource.new(container, resources)
  end

  # return codes
  # true  : container started
  # false : container does not exist
  def start(name : String) : Bool
    `lxc-start -n #{name} --quiet`
    return $?.success?
  end

  # return codes
  # true  : container stop
  # false : container does not exist
  def stop(name : String) : Bool
    `lxc-stop -n #{name} --quiet`
    return $?.success?
  end

  #
  def template_list
    return @helpers.template_list("#{@config_path}/#{@template_cache}")
  end

  #
  def _get_default_template : Template
    return @default_template
  end
end
