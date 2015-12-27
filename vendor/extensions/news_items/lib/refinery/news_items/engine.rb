module Refinery
  module NewsItems
    class Engine < Rails::Engine
      extend Refinery::Engine
      isolate_namespace Refinery::NewsItems

      engine_name :refinery_news_items

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.name = "news_items"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.news_items_admin_news_items_path }
          plugin.pathname = root
          
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::NewsItems)
      end
    end
  end
end
