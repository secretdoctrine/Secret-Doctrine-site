module Refinery
  module Books
    class BookCategoriesController < BaseController

      layout 'layouts/library.haml', :only => [:index, :show]

      before_action :set_body_class, :build_tree, :set_page_title

      def set_body_class
        @body_class = 'bluegamma'
      end

      def set_page_title
        @page_title = t('headers.library')
      end

      def build_tree
        @tree = BookCategory.build_categories_tree(current_element: BookCategory.find_by_id(params[:id]))
      end

      def index

        @library_news = NewsItem.where(library_news: true).order('news_datetime DESC')

      end

      def show

        @category = BookCategory.find_by_id(params[:id])
        return render_404 if @category.nil?
        @elements = @category.category_content
        @page_title += t('headers.separator') + @category.name

      end

    end
  end
end