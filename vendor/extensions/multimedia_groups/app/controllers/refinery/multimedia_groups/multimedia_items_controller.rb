module Refinery
  module MultimediaGroups
    class MultimediaItemsController < ::ApplicationController

      before_action :find_all_multimedia_items, :find_page

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
