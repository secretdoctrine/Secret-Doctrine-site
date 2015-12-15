class PagesController < ApplicationController

  layout 'layouts/application.haml', :only => [:index, :show]

  before_action :set_body_class, :build_tree, :build_contents

  def set_body_class
    @body_class = :bluegamma
  end

  def build_tree
    @book = Book.find_by_id(params[:book_id])
    @tree = BookCategory.build_categories_tree_for_book(@book)
  end

  def build_contents

    @book = Book.find_by_id(params[:book_id])
    @contents = @book.build_contents unless @book.nil?
    @contents

  end

  def show

    @page = Page.find_by_book_id_and_internal_order(params[:book_id], params[:id])

    render_404 if @page.nil?

  end

  def index
  end
end
