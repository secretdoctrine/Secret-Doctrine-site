module Refinery
  module Books
    class LibraryLinksController < BaseController

      layout 'layouts/clean.haml', :only => [:index, :show]

      before_action :set_body_class

      def set_body_class
        @body_class = 'bluegamma'
      end

      def show

        @library_link = LibraryLink.find_by_id(params[:id])

        return redirect_to @library_link.link

      end

    end
  end
end