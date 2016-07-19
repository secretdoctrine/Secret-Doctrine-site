module Refinery
  module Books
    class PagesController < BaseController

      layout 'layouts/library.haml', :only => [:index, :show]

      before_action :set_body_class, :set_page_title

      def set_body_class
        @body_class = 'bluegamma'
      end

      def set_page_title
        @page_title = t('headers.library')
      end

      def show

        @page_info = {}

        @page = BookPage.find_by_book_id_and_url_name(params[:book_id], params[:id])
        return render_404 if @page.nil?

        @page_info[:page] = @page
        @page_info[:tree] = BookCategory.build_categories_tree_for_book(@page.book)
        @page_info[:contents] = @page.book.build_contents(@page)
        @page_info[:pdf] =
            ((params.has_key?('pdf') and params['pdf'] == 'true' and not @page.pdf_content.nil?) or @page.html_content.nil?)
        @page_info[:pages_for_select] = @page.book.pages_for_select

        @page_title += t('headers.separator') + @page.book.name + t('headers.separator') + t('headers.page_number') + @page.url_name

      end

      def export

        @page = BookPage.find_by_book_id_and_url_name(params[:book_id], params[:id])
        render_404 if @page.nil?

        if @page.pdf_content
          type = 'application/pdf'
          extension = '.pdf'
          file_path = @page.pdf_content.path
        else
          type = 'application/html'
          extension = '.html'
          file_path = @page.html_content.path
        end


        send_file(
            #File.read(File.expand_path(@page.pdf_content.path)),
            File.expand_path(File.join(Rails.root, file_path)),
            type: type,
            disposition: 'attachment',
            filename: @page.short_book_and_page_name + extension
        )

      end

      def redirect

        return render_404 unless params.has_key? :id
        redirect_to refinery.books_book_page_path(params)

      end

    end
  end
end