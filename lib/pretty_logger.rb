# frozen_string_literal: true

require_relative "pretty_logger/version"
require_relative "pretty_logger/pretty_logger"
require_relative "pretty_logger/override_console_colors"
require_relative "pretty_logger/request_logger"
require_relative "pretty_logger/controller_methods"
require_relative "pretty_logger/railtie" if defined?(Rails)

module PrettyLogger
  class Error < StandardError; end
end
