VERSION = {{ `shards version #{__DIR__}`.chomp.stringify }}
HELP    = <<-HELP
admiractl version #{VERSION}

list
    --sort {field} ---- ex: name, disk{_usage}, cpu{_usage}, ram{_usage}, critical_usage, ip

create {name}
    --template {template_name}

set {name}
    --cpus N
    --ram  N{unit} ---- ex: 1G or 256M
    --disk N{unit}
    --hostname {hostname}
    --user {user_name} --password {password}

start|stop|restart {name}
HELP
