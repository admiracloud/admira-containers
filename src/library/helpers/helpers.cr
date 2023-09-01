# satndard libraries
require "http/client"

# classes
require "../classes/container.cr"
require "../classes/template.cr"

struct Helpers
  def container_list(raw : String) : Array(Container)
    list = [] of Container
    lines = 0

    raw.each_line do |line|
      if lines == 0
        lines += 1
        next
      end

      fields = line.split
      container = Container.new(fields[0].downcase, fields[1].downcase)

      if container.state == "running"
        usage = _usage(fields[0])
        container.cpus = usage["cpus"]
        container.loadavg = usage["loadavg"]
        container.ram = usage["memory_total"]
        container.ram_usage = "#{usage["memory_used"]} (#{usage["memory_used_percent"]})"
        container.disk = usage["disk_total"]
        container.disk_usage = "#{usage["disk_used"]} (#{usage["disk_used_percent"]})"
      end

      list << container

      lines += 1
    end

    return list
  end

  def template_list(cache_file : String) : Hash(String, Template)
    if File.exists?(cache_file)
      timespan = Time.local - File.info(cache_file).modification_time
      return Hash(String, Template).from_json(File.read(cache_file)) if timespan.total_hours < 24
    end

    response = HTTP::Client.get("https://images.linuxcontainers.org/meta/1.0/index-system")

    if response.status_code != 200
      puts "Unable to connect to remote image server"
      exit
    end

    list = Hash(String, Template).new

    response.body.lines.each do |line|
      fields = line.split(';')
      if (fields[2] == "amd64" && (fields[3] == "default" || fields[3] == "systemd"))
        shortname_version = fields[1] != "current" ? _distribution_codename_to_version(fields[0], fields[1]) : ""
        shortname = "#{fields[0]}#{shortname_version}-#{fields[2]}"
        list[shortname] = Template.new(fields[0], fields[1] != "current" ? fields[1] : "", fields[2])
      end
    end

    File.write(cache_file, list.to_json, mode: "w+")

    return list
  end

  def _usage(name : String) : Hash(String, String)
    result = Hash(String, String).new

    Process.run(command: "lxc-attach", args: [name]) do |s|
      i = s.input
      o = s.output

      i.puts "free -m"
      temp = [] of String
      temp << o.gets.as(String).strip
      temp << o.gets.as(String).strip
      temp << o.gets.as(String).strip
      memory_raw = temp[1].split
      result["memory_total"] = _mega_to_giga(memory_raw[1])
      result["memory_used"] = _mega_to_giga(memory_raw[2])
      result["memory_used_percent"] = "#{((memory_raw[2].to_f/memory_raw[1].to_f)*100).round(0).to_i}%"

      i.puts "hostname -f"
      result["hostname"] = o.gets.as(String).strip

      i.puts "cat /proc/loadavg"
      result["loadavg"] = o.gets.as(String).split[..2].join(" ").strip

      i.puts "nproc --all"
      result["cpus"] = o.gets.as(String).strip

      i.puts "df -h"
      o.gets # skips tye first line
      disk_raw = o.gets.as(String).split
      result["disk_total"] = disk_raw[1]
      result["disk_used"] = disk_raw[2]
      result["disk_used_percent"] = disk_raw[4]

      i.puts "exit"
    end

    return result
  end

  def _mega_to_giga(number : String)
    float = number.to_f
    return float > 1024 ? "#{(float/1024).round(1)}G" : "#{number}M"
  end

  def _distribution_codename_to_version(distribution : String, codename : String) : String
    ubuntu_codenames = {"trusty" => "14.04", "xenial" => "16.04", "bionic" => "18.04", "focal" => "20.04", "jammy" => "22.04", "lunar" => "23.04", "mantic" => "23.10"}
    debian_codenames = {"bookworm" => "12", "bullseye" => "11", "buster" => "10"}

    case distribution
    when "debian"
      return debian_codenames.has_key?(codename) ? "-#{debian_codenames[codename]}" : "-#{codename}"
    when "ubuntu"
      return ubuntu_codenames.has_key?(codename) ? "-#{ubuntu_codenames[codename]}" : "-#{codename}"
    else
      return "-#{codename}"
    end
  end
end
