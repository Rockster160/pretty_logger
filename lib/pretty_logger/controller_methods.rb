module PrettyLogger::ControllerMethods
  def pretty_logit
    request_logger.log_request
  end

  def request_logger
    @request_logger ||= ::PrettyLogger::RequestLogger.new(
      devise_current_agent: devise_current_agent,
      impersonating: impersonating?,
      current_agent: current_agent,
      request: request,
    )
  end
end
