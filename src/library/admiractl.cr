struct Admiractl
  def create(args : Array(String))
    # TODO
    # check if container already exists, first

    `lxc-create -n #{args[0]} --template debian-12-download --quiet`
    if $?.success?
      puts "Container #{args[0]} created successfully"
    else
      puts "An error occurred while attempting to create the container #{args[0]}"
    end
    exit
  end
end
