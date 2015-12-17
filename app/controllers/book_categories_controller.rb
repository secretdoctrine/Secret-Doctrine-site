class BookCategoriesController < ApplicationController

  layout 'layouts/library.haml', :only => [:index, :show]

  before_action :set_body_class, :build_tree

  def set_body_class
    @body_class = 'bluegamma'
  end

  def build_tree
    @tree = BookCategory.build_categories_tree(BookCategory.find_by_id(params[:id]))
  end

  def index

    @library_news = News.where(library_news: true).sort_by{ |x| x.news_datetime }

  end

  def show

    @category = BookCategory.find_by_id(params[:id])
    render_404 if @category.nil?
    @books = @category.nil? ? [] : @category.recursive_books_array

  end

end