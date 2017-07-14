module Refinery
  module Books
    class BooksController < BaseController

      layout 'layouts/library.haml', :only => [:index, :show]

      before_action :set_body_class

      def set_body_class
        @body_class = 'bluegamma'
      end

      def show

        @book = Book.includes(:book_pages).find_by_id(params[:id])

        return render_404 if @book.nil?

        use_pdf = true
        use_pdf = false if params.has_key?('pdf') and params['pdf'] == 'false'
        redirect_to refinery.books_book_page_path(@book, @book.book_pages.sort { |x, y| x.internal_order <=> y.internal_order}.first.url_name, :pdf => use_pdf)

      end

      def cover

        @book = Book.find_by_id(params[:id])
        return render_404 if @book.nil?
        return render_404 if @book.cover_picture.nil?
#::Refinery::Image
        send_file(
            #File.expand_path(@book.picture_path), #
            # @book.cover_picture.image,
            "#{Rails.root}/public/#{@book.cover_picture.url}",
            disposition: :inline)

      end

      def export_yml

        @book = Book.find_by_id(params[:id])
        #print @book.export_yml
        send_data @book.export_yml, :disposition => :inline

      end

    end
  end
end