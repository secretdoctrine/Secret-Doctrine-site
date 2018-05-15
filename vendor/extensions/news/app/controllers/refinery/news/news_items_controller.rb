module Refinery
  module News
    class NewsItemsController < ::ApplicationController

      before_action :find_all_news_items, :find_page, :set_page_title

      def set_page_title
        @page_title = t('headers.news')
      end

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @news_item in the line below:

        respond_to do |format|
          format.html {
            @news_dictionary = NewsItem.filter_by_params(@news_items, params)

            @news_recipient = NewsRecipient.new
            @news_categories = NewsCategory.all

            present(@page)
          }
          format.js {
            @news_dictionary = NewsItem.filter_by_params(@news_items, params)
            return render :layout => false
          }

        end
      end

      def show
        @news_item = NewsItem.find(params[:id])

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @news_item in the line below:
        present(@page)
      end

    protected

      def find_all_news_items
        @news_items = NewsItem.all
        #@news_items = NewsItem.where(:site_news => true).order('news_datetime DESC')
      end

      def find_page
        @page = ::Refinery::Page.where(:link_url => "#{Rails.application.config.refinery_root}/news_items").first
      end

    end
  end
end
