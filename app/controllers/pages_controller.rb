class PagesController < ApplicationController

  layout 'layouts/library.haml', :only => [:index, :show]

  before_action :set_body_class, :build_tree, :build_contents

  def set_body_class
    @body_class = 'bluegamma'
  end

  def build_tree
    @book = Book.find_by_id(params[:book_id])
    @tree = BookCategory.build_categories_tree_for_book(@book)
  end

  def build_contents

    page = Page.find_by_book_id_and_url_name(params[:book_id], params[:id])
    @contents = page.book.build_contents(page) unless page.nil?
    @contents

  end

  def show

    @page = Page.find_by_book_id_and_url_name(params[:book_id], params[:id])
    render_404 if @page.nil?

  end

  def export

    @page = Page.find_by_book_id_and_url_name(params[:book_id], params[:id])
    render_404 if @page.nil?

    send_file(
        #File.read(File.expand_path(@page.pdf_content.path)),
        File.expand_path(@page.pdf_content.path),
        type: 'application/pdf',
        disposition: 'attachment',
        filename: @page.short_book_and_page_name + '.pdf'
    )

  end

  def index
  end
end
