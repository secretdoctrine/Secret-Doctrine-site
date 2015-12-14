class PagesController < ApplicationController

  layout 'layouts/application.haml', :only => [:index, :show]

  before_action :set_body_class, :build_tree

  def set_body_class
    @body_class = :bluegamma
  end

  def build_tree
    @book = Book.find_by_id(params[:book_id])
    @tree = BookCategory.build_categories_tree_for_book(@book)
  end

  def show

    @page = Page.find_by_book_id_and_internal_order(params[:book_id], params[:id])

    render_404 if @page.nil?

  end

  def index
  end
end
