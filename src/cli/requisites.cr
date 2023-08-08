require "./help.cr"

struct Requisites
  def is_root
    user = `id -u -n`.strip
    if user != "root"
      puts "admiractl must be run as root. Current user: #{user}"
      exit
    end
  end

  def has_args
    if ARGV.size == 0
      puts HELP
      exit
    end
  end
end
