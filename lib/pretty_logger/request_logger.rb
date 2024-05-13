class PrettyLogger::RequestLogger
  attr_accessor :request, :current_agent, :impersonating, :devise_current_agent

  def initialize(devise_current_agent:nil, impersonating:nil, current_agent:nil, request:nil)
    @devise_current_agent = devise_current_agent
    @impersonating = impersonating
    @current_agent = current_agent
    @request = request
  end

  def log_request
    ::PrettyLogger::BaseLogger.info([
      "#{request_user} #{request.method.upcase} #{request.path}",
      params.blank? ? nil : ::PrettyLogger::BaseLogger.pretty_message(params).truncate(2000),
    ].compact.join("\n"))
  end

  def log_error(exception)
    ::PrettyLogger::BaseLogger.error([
      "#{request_user} #{request.path} #{colorize(:red, exception.class)}",
      params.blank? ? nil : ::PrettyLogger::BaseLogger.pretty_message(params).truncate(2000),
      colorize(:red, focused_backtrace(exception.backtrace).first),
      colorize(:red, clean_message("#{exception.class} #{exception.message}")),
    ].compact.join("\n"))
  end

  def params
    return unless @request.present?

    @request.filtered_parameters.except(:action, :controller, :id, :authenticity_token, :_method)
  end

  def request_user
    user_str = colored_user(devise_current_agent)
    user_str += colored_user(current_agent, impersonate: true) if impersonating

    user_str
  end

  def colored_user(user, impersonate: false)
    name_color, letter = :grey, "?" if user.blank?

    name_color ||= (
      case user.id
      when 1 then :rocco # Rocco
      when 22 then :green # B
      when 4 then :maroon # Jeff
      when 21 then :olive # Eric
      when 11 then :purple # Derek
      else :magenta
      end
    )

    letter ||= user.first_name.to_s[0].presence || user.id
    colorize(name_color, impersonate ? "(#{letter})" : "[#{letter}]")
  end
end
