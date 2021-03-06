class CreateBooksNewsItems < ActiveRecord::Migration
  def up

    create_table :refinery_books_news_items do |t|

      t.text      :body,          :limit => 65535, :null => false
      t.string    :title,         :null => false
      t.boolean   :library_news,  :default => false, :null => false
      t.boolean   :site_news,     :default => true, :null => false
      t.datetime  :news_datetime, :null => false
      t.integer   :position

      t.timestamps

    end

  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-news"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/news/news_items"})
    end

    drop_table :refinery_books_news_items

  end
end
