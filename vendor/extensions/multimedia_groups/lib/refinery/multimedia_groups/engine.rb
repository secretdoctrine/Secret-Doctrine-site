module Refinery
  module MultimediaGroups
    class Engine < Rails::Engine
      extend Refinery::Engine
      isolate_namespace Refinery::MultimediaGroups

      engine_name :refinery_multimedia_groups

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.name = "multimedia_groups"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.multimedia_groups_admin_multimedia_groups_path }
          plugin.pathname = root
          
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::MultimediaGroups)
      end
    end
  end
end
