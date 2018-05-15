module Refinery
  module News
    class NewsCategory < Refinery::Core::BaseModel
      self.table_name = 'refinery_news_items_news_categories'
      has_many :item_categories, :foreign_key => 'news_items_news_category_id'
      has_many :items, :through => 'item_categories'

      SITE_ADMIN_NC_TYPE = 0
      LIBRARY_UPDATE_NC_TYPE = 1
      MULTIMEDIA_UPDATE_NC_TYPE = 2
      GENERAL_NEWS_NC_TYPE = 3


    end
  end
end