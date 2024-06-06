module PrettyLogger
  module_function

  COLORS = {
    debug: "\e[90m",
    info: "\e[96m",
    warn: "\e[93m",
    error: "\e[31m",
  }

  def instance
    @instance ||= ::ActiveSupport::Logger.new("log/custom.log")
  end

  def timestamp
    Time.current.in_time_zone("Mountain Time (US & Canada)").strftime("[%b %d, %I:%M:%S%P]")
  end

  def pretty_message(obj)
    return obj if obj.is_a?(::String)

    ::CodeRay.scan(obj, :ruby).terminal.gsub(
      /\e\[36m:(\w+)\e\[0m=>/i, ("\e[36m" + '\1: ' + "\e[0m") # hashrocket(sym) to colon(sym)
    ).gsub(
      /\e\[0m=>/, "\e[0m: " # all hashrockets to colons
    ).gsub(
      # grey out nils
      "\e[1;36mnil\e[0m", "\e[1;90mnil\e[0m"
    )
  end

  def pretty_log(level, *messages)
    message = messages.compact.map { |m| pretty_message(m) }.join("\n")
    instance.send(level, "\e[90m#{timestamp}#{COLORS[level]}[#{level.to_s.upcase}]\e[0m#{message}")
  end

  def debug(*messages)
    pretty_log(:debug, *messages)
  end

  def info(*messages)
    pretty_log(nil, *messages) # nil makes it so `info` level doesn't show a prefix
  end

  def warn(*messages)
    pretty_log(:warn, *messages)
  end

  def error(*messages)
    pretty_log(:error, *messages)
  end

  def cl
    "\033[0m"
  end

  def rgb(r, g, b)
    "\033[38;2;#{r};#{g};#{b}m"
  end

  def colorize(name, text)
    return "" if text.blank?
    "#{colors[name]}#{text}#{cl}"
  end

  def colors
    {
      black:   rgb(0, 0, 0),
      white:   rgb(255, 255, 255),
      lime:    rgb(0, 255, 0),
      red:     rgb(255, 0, 0),
      blue:    rgb(0, 0, 255),
      yellow:  rgb(255, 255, 0),
      cyan:    rgb(0, 255, 255),
      magenta: rgb(255, 0, 255),
      gold:    rgb(218, 165, 32),
      silver:  rgb(192, 192, 192),
      grey:    rgb(150, 150, 150),
      maroon:  rgb(128, 0, 0),
      olive:   rgb(128, 128, 0),
      green:   rgb(0, 128, 0),
      purple:  rgb(128, 0, 128),
      teal:    rgb(0, 128, 128),
      navy:    rgb(0, 0, 128),
      rocco:   rgb(1, 96, 255),
      orange:  rgb(255, 150, 0),
      pink:    rgb(255, 150, 150),
    }
  end

  def focused_backtrace(trace)
    return [] unless trace
    trace.select { |line|
      line.include?("/app/")
    }.map { |line|
      line.gsub(/^.*?#{Rails.root}/, "").gsub(/(app)?\/app\//, "app/").gsub(":in `", " `").gsub(/(:\d+) .*?$/, '\1')
    }
  end

  def clean_message(message)
    message.gsub(/\#\<([\w\:]+)( id: \d+)?.*?\>\n/im) { |found|
      "#<#{Regexp.last_match(1)}#{Regexp.last_match(2)}>\n"
    }
  end

  def truncate(input, max_visible_length=2000, with: "...")
    full = input.length
    return input if full <= max_visible_length

    clean = input.gsub(/\e\[[\d;]*[a-z]/i, "").length
    return input if clean <= max_visible_length

    max_visible_length -= with.gsub(/\e\[[\d;]*[a-z]/i, "").length

    visible_length = 0
    truncated_string = ""

    input.scan(/(\e\[[\d;]*[a-z]|[^\e]+)/i) do |match|
      part = match[0]
      if part.match?(/\e\[[\d;]*[a-z]/i) # Match ANSI escape sequences
        truncated_string += part # Do not add to the count
      else
        part.each_char do |char|
          if visible_length < max_visible_length
            truncated_string += char
            visible_length += 1
          else
            break
          end
        end
      end
    end

    "#{truncated_string}#{with}"
  end
end
