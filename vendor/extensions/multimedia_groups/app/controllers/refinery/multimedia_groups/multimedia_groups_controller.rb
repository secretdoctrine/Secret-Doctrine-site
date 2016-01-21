module Refinery
  module MultimediaGroups
    class MultimediaGroupsController < ::ApplicationController

      before_action :find_root_multimedia_groups
      before_action :find_page

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @multimedia_group in the line below:
        present(@page)
      end

      def show
        @multimedia_group = MultimediaGroup.find(params[:id])

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @multimedia_group in the line below:
        present(@page)
      end

    protected

      def find_root_multimedia_groups
        @root_multimedia_groups = MultimediaGroup.where(:multimedia_group_id => nil).order('position ASC')
      end

      def find_page
        @page = ::Refinery::Page.where(:link_url => "#{Rails.application.config.refinery_root}/multimedia_groups").first
      end

    end
  end
end
