module Refinery
  module NewsItems
    class NewsItemsController < ::ApplicationController

      before_action :find_all_news_items
      before_action :find_page

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @news_item in the line below:
        @news_recipient = NewsRecipient.new
        present(@page)
      end

      def show
        @news_item = NewsItem.find(params[:id])

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @news_item in the line below:
        present(@page)
      end

    protected

      def find_all_news_items
        @news_items = NewsItem.where(:site_news => true).order('position ASC')
      end

      def find_page
        @page = ::Refinery::Page.where(:link_url => "#{Rails.application.config.refinery_root}/news_items").first
      end

    end
  end
end
