module Refinery
  module Books
    class ExternalPageContentsController < BaseController

      def show

        @content_item = ExternalPageContent.find_by_id(params[:id])
        return render_404 if @content_item.nil?
        return render_404 unless File.exist?(File.join(Rails.root, @content_item.path))

        return send_file(File.join(Rails.root, @content_item.path), disposition: :inline) unless @content_item.is_html

        @content = File.read(File.join(Rails.root, @content_item.path))

        render :layout => false

      end

    end
  end
end