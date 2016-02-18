module Refinery
  module FeedbackEntries
    class Engine < Rails::Engine
      extend Refinery::Engine
      isolate_namespace Refinery::FeedbackEntries

      engine_name :refinery_feedback_entries

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.name = "feedback_entries"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.feedback_entries_admin_feedback_entries_path }
          plugin.pathname = root
          
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::FeedbackEntries)
      end
    end
  end
end
