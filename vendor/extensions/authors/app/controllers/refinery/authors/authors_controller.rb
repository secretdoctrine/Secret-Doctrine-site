module Refinery
  module Authors
    class AuthorsController < ::ApplicationController

      before_action :find_all_authors
      before_action :find_page

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @author in the line below:
        present(@page)
      end

      def show
        @author = Author.friendly.find(params[:id])

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @author in the line below:
        present(@page)
      end

    protected

      def find_all_authors
        @authors = Author.order('position ASC')
      end

      def find_page
        @page = ::Refinery::Page.where(:link_url => "#{Rails.application.config.refinery_root}/authors").first
      end

    end
  end
end
