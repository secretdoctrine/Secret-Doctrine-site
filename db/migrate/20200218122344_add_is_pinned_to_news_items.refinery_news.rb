# This migration comes from refinery_news (originally 5)
class AddIsPinnedToNewsItems < ActiveRecord::Migration

  def change

    add_column :refinery_books_news_items, :is_pinned, :boolean, :null => false, :default => false

  end

end