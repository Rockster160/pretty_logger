module PrettyLogger
  class Railtie < ::Rails::Railtie
    initializer "pretty_logger.configure_rails_initialization" do
      ActiveSupport.on_load(:action_controller) do
        include PrettyLogger::ControllerMethods

        before_action :pretty_logit
        rescue_from ::StandardError, with: :prettylog_and_reraise!
      end
    end
  end
end
