class PagesController < ApplicationController

  layout 'layouts/library.haml', :only => [:index, :show]

  before_action :set_body_class

  def set_body_class
    @body_class = 'bluegamma'
  end

  def show

    @page_info = {}

    @page = Page.find_by_book_id_and_url_name(params[:book_id], params[:id])
    render_404 if @page.nil?

    @page_info[:page] = @page
    @page_info[:tree] = BookCategory.build_categories_tree_for_book(@page.book)
    @page_info[:contents] = @page.book.build_contents(@page)
    @page_info[:pdf] = (params.has_key?('pdf') and params['pdf'] == 'true')

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
