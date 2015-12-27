module Refinery
  module NewsItems
    module Admin
      class NewsItemsController < ::Refinery::AdminController

        crudify :'refinery/news_items/news_item',
                :title_attribute => 'body'

        private

        # Only allow a trusted parameter "white list" through.
        def news_item_params
          params.require(:news_item).permit(:body, :library_news, :site_news, :news_datetime)
        end
      end
    end
  end
end
