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
      list << Container.new(fields[0].downcase, fields[1].downcase)

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
