module PrettyLogger::ControllerMethods
  def pretty_logit
    request_logger.log_request
  end

  def request_logger
    @request_logger ||= ::PrettyLogger::RequestLogger.new(request: request)
  end

  def prettylog_and_reraise!(exception)
    request_logger.log_error(exception)
    raise exception
  end
end
