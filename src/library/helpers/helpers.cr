require "../classes/container.cr"

struct Helpers
  def container_list(raw : String)
    list = [] of Container
    lines = 0

    raw.each_line do |line|
      if lines == 0
        lines += 1
        next
      end

      fields = line.split
      container = Container.new(fields[0].downcase, fields[1].downcase)
      list << container

      lines += 1
    end

    return list
  end
end
