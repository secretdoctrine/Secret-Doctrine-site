module Refinery
  module News
    class ItemCategory < Refinery::Core::BaseModel
      self.table_name = 'refinery_news_items_news_items_news_categories'
      belongs_to :news_category, foreign_key: 'news_items_news_category_id', class_name: 'NewsCategory'
      belongs_to :item, foreign_key: 'news_items_news_item_id', class_name: 'NewsItem'
    end
  end
end