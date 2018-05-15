class CreateNewsItemsNewsItemsNewsCategories < ActiveRecord::Migration

  def change
    create_table :refinery_news_items_news_items_news_categories, id: false do |t|
      t.belongs_to :news_items_news_item
      t.belongs_to :news_items_news_category
    end


    library_news_category = ::Refinery::News::NewsCategory.find_by(category_type: ::Refinery::News::NewsCategory::LIBRARY_UPDATE_NC_TYPE)
    site_news_category = ::Refinery::News::NewsCategory.find_by(category_type: ::Refinery::News::NewsCategory::SITE_ADMIN_NC_TYPE)

    ::Refinery::News::NewsItem.where(library_news: true).each { |x| library_news_category.items << x }
    ::Refinery::News::NewsItem.where(site_news: true).each { |x| site_news_category.items << x }

  end

end