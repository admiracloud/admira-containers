# admiractl

admiractl is a system container manager for Linux containers. It aims to provide containers as faster alternatives to virtual machines (VMs), together with all the functionality necessary to manage those, including hardware resources, OS templates, network and storage.

The complete library is packed in a compiled binary, and it can be used through cli interface or sockets REST API.

## Minimum requirements

Because it is meant to be used only with cgroups v2, the minimum requirements are:

- Linux Kernel version is 5.8 or later (LTS versions from 5.10+ recommended)
- Linux distribution with cgroups v2 support (see list below)

**Compatible Linux distributions**

- Ubuntu (since 21.10, 22.04+ recommended)
- Debian (since 11 bullseye)
- Fedora (since 31)
- Arch Linux (since April 2021)
- RHEL and derivatives (since 9)

## Development roadmap

This is the current development status for the CLI:

**Container management**
- [x] `create <name>` container with default template
- [ ] `create --template <template_name>` container with chosen template
- [x] basic `list` containers
- [ ] complete `list` containers, with resource usage stats
- [x] `start <name>`, `stop <name>` and `restart <name>`
- [x] `delete <name>` container

**Resource management (cpu, ram, storage)**
- [ ] `set <name> --cpus N`
- [x] `set <name> --ram N{unit}`
- [ ] `set <name> --disk N{unit}`

**General management**
- [ ] `set <name> --hostname <hostname>`
- [ ] `set <name> --user <username> --password`
- [x] `enter <name>` to initiate a terminal session inside a container

**Template management**
- [ ] `template list` 
- [ ] `template download <template_name>`
- [ ] `template update <template_name>`

**Network management**
- [ ] `ip4 add` and `ip4 remove` 
- [ ] `ip6 add` and `ip6 remove`

**Quality**
- [ ] Automated tests

## Contributing

1. Fork it (<https://github.com/admiracloud/admira-containers/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Paulo Coghi](https://github.com/paulocoghi) - creator and maintainer

(c) Copyright by Admira Cloud LLC (previously Adimira LLC)
