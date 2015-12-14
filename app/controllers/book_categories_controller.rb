class BookCategoriesController < ApplicationController

  layout 'layouts/application.haml', :only => [:index, :show]

  before_action :set_body_class, :build_tree

  def set_body_class
    @body_class = :bluegamma
  end

  def build_tree
    @tree = BookCategory.build_categories_tree(BookCategory.find_by_id(params[:id]))
  end

  def index



  end

  def show

    @category = BookCategory.find_by_id(params[:id])
    @books = @category.nil? ? [] : @category.recursive_books_array

  end

end