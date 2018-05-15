class CreateNewsItemsNewsCategories < ActiveRecord::Migration

  def up
    create_table :refinery_news_items_news_categories do |t|
      t.string  :category_name, :limit => 255
      t.integer :category_type

      t.timestamps
    end

    add_index :refinery_news_items_news_categories, :category_type

    ::Refinery::News::NewsCategory.create!(category_name: 'Новости администрации сайта', category_type: ::Refinery::News::NewsCategory::SITE_ADMIN_NC_TYPE)
    ::Refinery::News::NewsCategory.create!(category_name: 'Обновления библиотеки', category_type: ::Refinery::News::NewsCategory::LIBRARY_UPDATE_NC_TYPE)
    ::Refinery::News::NewsCategory.create!(category_name: 'Обновления мультимедиа', category_type: ::Refinery::News::NewsCategory::MULTIMEDIA_UPDATE_NC_TYPE)
    ::Refinery::News::NewsCategory.create!(category_name: 'Общие новости', category_type: ::Refinery::News::NewsCategory::GENERAL_NEWS_NC_TYPE)

  end

  def down

    drop_table :refinery_news_items_news_categories

  end

end