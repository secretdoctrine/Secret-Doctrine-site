module Refinery
  module MultimediaGroups
    class MultimediaGroupsController < ::ApplicationController

      before_action :find_root_multimedia_groups, :find_page, :set_page_title

      def set_page_title
        @page_title = t('headers.multimedia')
      end

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @multimedia_group in the line below:
        present(@page)
      end

      def show
        @multimedia_group = MultimediaGroup.find(params[:id])

        @page_title += t('headers.separator') + @multimedia_group.title
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @multimedia_group in the line below:
        present(@page)
      end

    protected

      def find_root_multimedia_groups
        @root_multimedia_groups = MultimediaGroup.get_root!.multimedia_groups.sort_by{|x| x.order_number}
        #@root_multimedia_groups = MultimediaGroup.where(:multimedia_group_id => nil).order('position ASC')
      end

      def find_page
        @page = ::Refinery::Page.where(:link_url => "#{Rails.application.config.refinery_root}/multimedia_groups").first
      end

    end
  end
end
