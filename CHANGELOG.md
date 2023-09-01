# Admira Containers - admiractl changelog

## 0.11.0 - 2023-08-31

* Command "list" now provides resource usage stats for running containers

## 0.10.0 - 2023-08-31

* Added "--swap" as a possible resource to manage by the "set" command

## 0.9.0 - 2023-08-30

* Fully working "set" command for cpus

## 0.8.0 - 2023-08-26

* Improved "create" command with "--template" option
* Concluded persistency of hardware resource changes

## 0.7.0 - 2023-08-20

* Added "template [list]" command
* Added config folder creation
* Added caching for template list

## 0.6.0 - 2023-08-18

* Fully working "set" command for ram
* Fixed "enter" command output from the subshell

## 0.5.0 - 2023-08-12

* Added basic "set" command for cpus, ram, and hostname
* Added auto-completion to the cli

## 0.4.0 - 2023-08-10

* Added enter command
* Added verification of container status before start, stop and restart actions

## 0.3.0 - 2023-08-09

* Added delete, start, stop and restart commands
* cgroups v2 verification on runtime and information on readme

## 0.2.0 - 2023-08-08

* Added the basic list command - missing the version with resource usage stats

## 0.1.0 - 2023-08-07

* Added the create command - missing template flag
* Added the base for the cli project organization for modules, libraries and their directories