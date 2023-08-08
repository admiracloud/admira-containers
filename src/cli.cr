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

# cli modular library
require "./cli/help.cr"
require "./cli/validate.cr"

# admiractl library
require "./library/admiractl.cr"

# Cli root commands
struct Cli
  # create an instance of validator
  @validate = Validate.new
  @admiractl = Admiractl.new

  def start
    # Only run if the use is root
    @validate.is_root

    # make a copy of ARGV
    args = ARGV

    # When no argument is passed, show help
    if args.size == 0
      puts HELP
      exit
    end

    # Extract the first argument (a root command) and validate it
    arg = args.shift

    case arg
    when "list"
      puts "list"
    when "create"
      # Exit if invalid
      @validate.create(args)

      # Otherwise
      @admiractl.create(args)
    when "set"
      puts "set"
    when "-h", "--help", "help"
      puts HELP
    when "-v", "--version", "version"
      puts "admiractl version #{VERSION}"
    else
      puts "Invalid option: #{arg}"
    end

    # Otherwise, we have arguments
  end
end

cli = Cli.new
cli.start
