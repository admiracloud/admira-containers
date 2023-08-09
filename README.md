# admiractl

admiractl is a system container manager for Linux containers. Contrary to docker, it aims to provide containers as VMs and all the functionality necessary to manage those in just a single binary/executable.

It provides both a cli as well as a socket API

## Installation

TODO: Write installation instructions here

## Usage

TODO: Write usage instructions here

## Development roadmap

This is the current development status:

**Container management**
- [x] `create <name>` container with default template
- [ ] `create --template <template_name>` container with chosen template
- [x] basic `list` containers
- [ ] complete `list` containers, with resource usage stats
- [ ] `start <name>`, `stop <name>` and `restart <name>`
- [x] `delete <name>` container

**Resource management (cpu, ram, storage)**
- [ ] `set <name> --cpus N`
- [ ] `set <name> --ram N{unit}`
- [ ] `set <name> --disk N{unit}`

**General management**
- [ ] `set <name> --hostname <hostname>`
- [ ] `set <name> --user <username> --password`

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
