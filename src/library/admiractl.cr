require "./helpers/helpers.cr"

struct Admiractl
  # Helpers methods
  @helpers = Helpers.new

  def create(args : Array(String))
    # TODO
    # first check if container already exists, using list command
    `lxc-create -n #{args[0]} --template debian-12-download --quiet`
    return $?.success?
  end

  def list
    raw = `lxc-ls -f -F NAME,STATE,PID,RAM,SWAP,AUTOSTART,GROUPS,INTERFACE,IPV4,IPV6,UNPRIVILEGED`
    return @helpers.container_list(raw)
  end
end
