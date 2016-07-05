module Refinery
  module Books
    class PopupBooksController < BaseController

      layout 'layouts/clean.haml', :only => [:index, :show]

      before_action :set_body_class

      def set_body_class
        @body_class = 'bluegamma'
      end

      def show

        @popup_book = PopupBook.find_by_id(params[:id])

        render_404 if @popup_book.nil?

      end

    end
  end
end