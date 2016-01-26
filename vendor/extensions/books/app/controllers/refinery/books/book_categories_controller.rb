module Refinery
  module Books
    class BookCategoriesController < BaseController

      layout 'layouts/library.haml', :only => [:index, :show]

      before_action :set_body_class, :build_tree

      def set_body_class
        @body_class = 'bluegamma'
      end

      def build_tree
        @tree = BookCategory.build_categories_tree(current_element: BookCategory.find_by_id(params[:id]))
      end

      def index

        @library_news = NewsItem.where(library_news: true).sort_by{ |x| x.news_datetime }

      end

      def show

        @category = BookCategory.find_by_id(params[:id])
        return render_404 if @category.nil?
        @elements = @category.category_content

      end

    end
  end
end