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

  def template_list(cache_file : String) : Array(Template)
    if File.exists?(cache_file)
      timespan = Time.local - File.info(cache_file).modification_time
      return Array(Template).from_json(File.read(cache_file)) if timespan.total_hours < 24
    end

    response = HTTP::Client.get("https://images.linuxcontainers.org/meta/1.0/index-system")

    if response.status_code != 200
      puts "Unable to connect to remote image server"
      exit
    end

    list = [] of Template

    response.body.lines.each do |line|
      fields = line.split(';')
      if (fields[2] == "amd64" && (fields[3] == "default" || fields[3] == "systemd"))
        list << Template.new(fields[0], fields[1] != "current" ? fields[1] : "", fields[2])
      end
    end

    File.write(cache_file, list.to_json, mode: "w+")

    return list
  end
end
