module Refinery
  module MultimediaGroups
    class MultimediaItemsController < ::ApplicationController

      before_action :find_all_multimedia_items
      before_action :find_page

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @multimedia_item in the line below:
        present(@page)
      end

      def show
        @multimedia_item = MultimediaItem.find(params[:id])

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @multimedia_item in the line below:
        present(@page)
      end

    protected

      def find_all_multimedia_items
        @multimedia_items = MultimediaItem.order('position ASC')
      end

      def find_page
        @page = ::Refinery::Page.where(:link_url => "#{Rails.application.config.refinery_root}/multimedia_groups").first
      end

    end
  end
end
