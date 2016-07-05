module Refinery
  module Authors
    class PoemsController < ::ApplicationController

      before_action :find_all_poems, :find_page, :set_page_title

      def set_page_title
        @page_title = t('headers.authors')
      end

      def show
        @poem = Poem.find(params[:id])

        @page_title += t('headers.separator') + @poem.author.name + t('headers.separator') + @poem.title
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @poem in the line below:
        present(@page)
      end

    protected

      def find_all_poems
        @poems = Poem.order('position ASC')
      end

      def find_page
        @page = ::Refinery::Page.where(:link_url => "#{Rails.application.config.refinery_root}/authors").first
      end

    end
  end
end
