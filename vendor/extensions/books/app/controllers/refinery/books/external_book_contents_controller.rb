module Refinery
  module Library
    class ExternalBookContentsController < BaseController

      def show

        @content_item = ExternalBookContent.find_by_id(params[:id])
        return render_404 if @content_item.nil?
        return render_404 unless File.exist?(File.expand_path(@content_item.path))
        return render_404 unless @content_item.content_type == ExternalBookContent::PDF_TYPE

        send_file(
              File.expand_path(@content_item.path),
            disposition: :attachment,
            type: 'application/pdf',
            filename: @content_item.book.name + '.pdf')

      end

    end
  end
end