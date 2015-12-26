module Library
  class BooksController < ApplicationController

    layout 'layouts/library.haml', :only => [:index, :show]

    before_action :set_body_class

    def set_body_class
      @body_class = 'bluegamma'
    end

    def show

      @book = Book.includes(:pages).find_by_id(params[:id])

      return render_404 if @book.nil?

      redirect_to book_page_path(@book, @book.pages.sort { |x, y| x.internal_order <=> y.internal_order}.first.url_name)

    end

    def cover

      @book = Book.find_by_id(params[:id])
      return render_404 if @book.nil?
      return render_404 if @book.picture_path.nil? or not File.exist?(File.expand_path(@book.picture_path))

      send_file(
          File.expand_path(@book.picture_path),
          disposition: :inline)

    end

  end
end