module Refinery
  module MultimediaGroups
    class Engine < Rails::Engine
      extend Refinery::Engine
      isolate_namespace Refinery::MultimediaGroups

      engine_name :refinery_multimedia_groups

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.name = "multimedia_items"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.multimedia_groups_admin_multimedia_items_path }
          plugin.pathname = root
          plugin.menu_match = %r{refinery/multimedia_groups/multimedia_items(/.*)?$}
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::MultimediaItems)
      end
    end
  end
end
