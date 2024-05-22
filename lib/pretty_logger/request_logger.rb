class PrettyLogger::RequestLogger
  include PrettyLogger
  attr_accessor :request, :current_user

  def initialize(request:nil, current_user:nil)
    @request = request
    @current_user = current_user
  end

  def log_request(extra_text=nil)
    info([
      "#{pretty_user} #{request.method.upcase} #{request.path} #{extra_text}",
      params.blank? ? nil : truncate(pretty_message(params)),
    ].compact.join("\n"))
  end

  def log_error(exception)
    error([
      "#{pretty_user} #{request.path} #{colorize(:red, exception.class)}",
      params.blank? ? nil : truncate(pretty_message(params)),
      colorize(:red, focused_backtrace(exception.backtrace).first),
      colorize(:red, clean_message("#{exception.class} #{exception.message}")),
    ].compact.join("\n"))
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
