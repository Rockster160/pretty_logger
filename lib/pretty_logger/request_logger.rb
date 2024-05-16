class PrettyLogger::RequestLogger < PrettyLogger::BaseLogger
  attr_accessor :request, :current_user

  def initialize(request:nil, current_user:nil)
    @request = request
    @current_user = current_user
  end

  def log_request(extra_text=nil)
    # Nothing change
    ::PrettyLogger::BaseLogger.info([
      "#{pretty_user} #{request.method.upcase} #{request.path} #{extra_text}",
      params.blank? ? nil : truncate(::PrettyLogger::BaseLogger.pretty_message(params)),
    ].compact.join("\n"))
  end

  def log_error(exception)
    ::PrettyLogger::BaseLogger.error([
      "#{pretty_user} #{request.path} #{colorize(:red, exception.class)}",
      params.blank? ? nil : truncate(::PrettyLogger::BaseLogger.pretty_message(params)),
      colorize(:red, focused_backtrace(exception.backtrace).first),
      colorize(:red, clean_message("#{exception.class} #{exception.message}")),
    ].compact.join("\n"))
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

  def params
    return unless @request.present?

    @request.filtered_parameters.except(:action, :controller, :id, :authenticity_token, :_method)
  end

  def pretty_user
    return colorize(:grey, "[?]") unless current_user.present?

    name = current_user.try(:username).presence
    name ||= current_user.try(:name).presence
    name ||= "#{current_user.class.name}:#{current_user.id}"

    colorize(:magenta, "[#{name}]")
  end
end
