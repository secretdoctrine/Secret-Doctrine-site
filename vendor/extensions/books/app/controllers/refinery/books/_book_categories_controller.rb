module Refinery
  module Books
    class BookCategoriesController < ::ApplicationController

      before_action :find_all_book_categories
      before_action :find_page

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @book_category in the line below:
        present(@page)
      end

      def show
        @book_category = BookCategory.find(params[:id])

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @book_category in the line below:
        present(@page)
      end

    protected

      def find_all_book_categories
        @book_categories = BookCategory.order('position ASC')
      end

      def find_page
        @page = ::Refinery::Page.where(:link_url => "/book_categories").first
      end

    end
  end
end
