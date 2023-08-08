#!/usr/bin/env crystal

# admiractl
#
# Original Author:  Paulo Coghi
# Created:          08.04.2023
#
# Description:      System containers manager based on systemd-nspawn, currently based on cgroups v2 and namespaces
#
#                   It provides opinionated decisions about network configuration, storage configuration, sane defaults
#                   when defining hardware resource limits, basic statistics and monitoring for all the resources used.
#
#                   Despite being compatible with any chrooted Linux environment as a base for the system container,
#                   pre-made templates are created by Admira Cloud with inumerous configuration decisions torwards
#                   cloud computing production environments
#
#
# (c) Copyright by Admira Cloud LLC (previously Adimira LLC)

# requisites methods
require "./cli/requisites.cr"

# commands which validate args and call admiractl respective method
require "./cli/commands.cr"

# cli root commands
struct Cli
  @requisites = Requisites.new
  @commands = Commands.new

  def run
    # Check pre-requisites first

    # User must be root
    @requisites.is_root

    # There must be arguments (otherwise the help message will be printed)
    @requisites.has_args

    # Pre-requisites met
    # Lets start by making a copy of ARGV (global var which contains the command arguments)...
    args = ARGV

    # ...extracting the first argument (the root command)...
    arg = args.shift

    # ...and validating it, calling the respective command when it's valid

    case arg
    when "list"
      @commands.list
    when "create"
      @commands.create(args)
    when "set"
      puts "set"
    when "-h", "--help", "help"
      @commands.help
    when "-v", "--version", "version"
      @commands.version
    else
      puts "Invalid option: #{arg}"
    end
  end
end

cli = Cli.new
cli.run
