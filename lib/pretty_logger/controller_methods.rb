module PrettyLogger::ControllerMethods
  def pretty_logit(extra_text=nil)
    request_logger.log_request(extra_text)
  end

  def request_logger
    @request_logger ||= ::PrettyLogger::RequestLogger.new(
      request: request,
      current_user: try(:current_user)
    )
  end

  def prettylog_and_reraise!(exception)
    request_logger.log_error(exception)
    raise exception
  end
end
