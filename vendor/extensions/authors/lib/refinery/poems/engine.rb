module Refinery
  module Authors
    class Engine < Rails::Engine
      extend Refinery::Engine
      isolate_namespace Refinery::Authors

      engine_name :refinery_authors

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.name = "poems"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.authors_admin_poems_path }
          plugin.pathname = root
          plugin.menu_match = %r{refinery/authors/poems(/.*)?$}
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::Poems)
      end
    end
  end
end
