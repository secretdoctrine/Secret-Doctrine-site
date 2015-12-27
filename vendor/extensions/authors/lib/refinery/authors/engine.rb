module Refinery
  module Authors
    class Engine < Rails::Engine
      extend Refinery::Engine
      isolate_namespace Refinery::Authors

      engine_name :refinery_authors

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.name = "authors"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.authors_admin_authors_path }
          plugin.pathname = root
          
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::Authors)
      end
    end
  end
end
