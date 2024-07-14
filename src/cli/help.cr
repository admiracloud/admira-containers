VERSION = {{ `shards version #{__DIR__}`.chomp.stringify }}
HELP    = <<-HELP
admiractl version #{VERSION}

list
    [--sort <field>] ---- valid field values: name, disk[_usage], cpu[_usage], ram[_usage], critical_usage, ip

create <name>
    [--template <template_name>]

set <name>
[
    --cpus N
    --ram  N{unit} ---- ex: 1G or 256M
    --disk N{unit}
    --hostname <hostname>
    --user <username> [--password <password>]
]

start|stop|restart <name>

delete <name>

template list

proxy
      set <main_domain> --ip <ip> [ --additional <additional_domain_1>[,<additional_domain_2>] ]
      delete <main_domain>
      ssl --all | <main_domain>
      list


HELP
