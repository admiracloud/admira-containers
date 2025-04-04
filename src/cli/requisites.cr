require "./help.cr"

struct Requisites
  def cgroups_v2_check
    check : String = `stat -fc %T /sys/fs/cgroup/`.strip
    case check
    when "cgroup2fs"
      return # good
    when "tmpfs"
      # cgroups v1 identified -- bad
      puts "cgroups v2 is required, but v1 was identified on your system"
    else
      # cgroups not identified -- bad
      puts "Cannot identify which cgroups is installed/enabled"
    end

    puts "Check https://github.com/admiracloud/admira-containers about cgroups v2 requirements"
    exit
  end

  def fixed_local_ips_check
    check : String = `grep LXC_DHCP_CONFILE /etc/default/lxc-net`.strip
    # continue
    # #LXC_DHCP_CONFILE=/etc/lxc/dnsmasq.conf
    # or
    # LXC_DHCP_CONFILE=/etc/lxc/dnsmasq.conf
  end

  def has_args
    if ARGV.size == 0
      puts HELP
      exit
    end
  end

  def is_root
    user = `id -u -n`.strip
    if user != "root"
      # If autocompletion was called when non-root, returns nothing
      if ARGV.size > 0 && ARGV[0] == "__autocomplete"
        exit
      end

      puts "admiractl must be run as root. Current user: #{user}"
      exit
    end
  end
end
