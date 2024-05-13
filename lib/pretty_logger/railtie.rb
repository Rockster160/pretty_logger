module PrettyLogger
  class Railtie < ::Rails::Railtie
    initializer "pretty_logger.configure_rails_initialization" do
      ActiveSupport.on_load(:action_controller) do
        include PrettyLogger::ControllerMethods
      end
    end
  end
end
