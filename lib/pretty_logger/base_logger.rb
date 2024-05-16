# debug
# info
# warn
# error

class PrettyLogger::BaseLogger < ActiveSupport::Logger
  class << self
    def instance
      @instance ||= new("log/custom.log")
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
      )
    end

    def debug(message)
      instance.debug("\e[90m#{timestamp}\e[90m[DEBUG]\e[0m #{pretty_message(message)}")
    end

    def info(message)
      instance.info("\e[90m#{timestamp}\e[36m[INFO]\e[0m #{pretty_message(message)}")
    end

    def warn(message)
      instance.warn("\e[90m#{timestamp}\e[38;5;208m[WARN]\e[0m #{pretty_message(message)}")
    end

    def error(message)
      instance.error("\e[90m#{timestamp}\e[31m[ERROR]\e[0m #{pretty_message(message)}")
    end
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
end
