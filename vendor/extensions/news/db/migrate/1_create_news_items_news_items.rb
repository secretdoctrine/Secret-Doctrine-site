class CreateNewsItemsNewsItems < ActiveRecord::Migration

  def up
    create_table :refinery_news_items do |t|
      t.text :body
      t.boolean :library_news
      t.boolean :site_news
      t.datetime :news_datetime
      t.integer :position

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

    drop_table :refinery_news_items

  end

end
