module Refinery
  module News
    class Engine < Rails::Engine
      extend Refinery::Engine
      isolate_namespace Refinery::News

      engine_name :refinery_news

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.name = "news"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.news_admin_news_items_path }
          plugin.pathname = root
          
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::News)
      end
    end
  end
end
