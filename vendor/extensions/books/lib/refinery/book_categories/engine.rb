module Refinery
  module Books
    class Engine < Rails::Engine
      extend Refinery::Engine
      isolate_namespace Refinery::Books

      engine_name :refinery_books

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.name = "books"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.books_admin_book_categories_path }
          plugin.pathname = root
          #plugin.menu_match = %r{refinery/books/book_categories(/.*)?$}
        end
      end

      initializer :append_migrations do |app|
        unless app.root.to_s.match root.to_s
          config.paths["db/migrate"].expanded.each do |expanded_path|
            app.config.paths["db/migrate"] << expanded_path
          end
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::BookCategories)
      end
    end
  end
end
