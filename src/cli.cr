#!/usr/bin/env crystal

# admiractl
#
# Original Author:  Paulo Coghi
# Created:          08.04.2023
#
# Description:      System containers manager based on lxc, made exclusively for cgroups v2
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

# autocomplete methods
require "./cli/autocomplete.cr"

# cli root commands
class Cli
  def initialize
    # Prepare pre-requisites instance, to check them
    @requisites = Requisites.new

    # User must be root
    @requisites.is_root

    # cgroups v2 must be enabed
    @requisites.cgroups_v2_check

    # fixed local ips
    @requisites.fixed_local_ips_check

    # When no arguments are passed, the help message will be printed
    @requisites.has_args

    # Pre-requisites met
    # Instantiate command (and admiractl library internally)
    @commands = Commands.new
  end

  def run
    # Lets start by making a copy of ARGV (global var which contains the command arguments)...
    args = ARGV

    # ...extracting the first argument (the root command)...
    arg = args.shift

    # ...and validating it, calling the respective command when it's valid

    case arg
    when "create"
      @commands.create(args)
    when "delete"
      @commands.delete(args)
    when "enter"
      return @commands.enter(args)
    when "list"
      @commands.list
    when "set"
      @commands.set(args)
    when "start"
      @commands.start(args)
    when "stop"
      @commands.stop(args)
    when "restart"
      @commands.restart(args)
    when "template"
      @commands.template(args)
    when "proxy"
      @commands.proxy(args)
    when "-h", "--help", "help"
      @commands.help
    when "-v", "--version", "version"
      @commands.version
    when "__autocomplete"
      Autocomplete.new.run(args)
    else
      puts "Invalid option: #{arg}"
    end
  end
end

cli = Cli.new
cli.run
