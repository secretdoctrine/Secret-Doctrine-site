module Refinery
  module News
    class NewsCategoriesController < ::ApplicationController

      def set_page_title
        @page_title = t('headers.news')
      end


      def show
        @news_category = NewsCategory.find(params[:id])
        category_items = @news_category.items.all
        @news_dictionary = NewsItem.filter_by_params(category_items, params)

        @news_recipient = NewsRecipient.new
        @news_categories = NewsCategory.all

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @news_item in the line below:
        present(@page)
      end

      protected

      def find_page
        @page = ::Refinery::Page.where(:link_url => "#{Rails.application.config.refinery_root}/news_items").first
      end

    end
  end
end
