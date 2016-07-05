module Refinery
  module Authors
    class AuthorsController < ::ApplicationController

      before_action :find_all_authors, :find_page, :set_page_title

      def set_page_title
        @page_title = t('headers.authors')
      end

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @author in the line below:
        root = Author.get_root!
        author = root.authors.sort_by{|x| x.order_number}.first
        return redirect_to refinery.authors_author_path(author.id) if author
        present(@page)
      end

      def show
        @author = Author.friendly.find(params[:id])

        @page_title += t('headers.separator') + @author.name

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
