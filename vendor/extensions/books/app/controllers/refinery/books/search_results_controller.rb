module Refinery
  module Books
    class SearchResultsController < BaseController

      layout 'layouts/library.haml', :only => [:index]

      before_action :set_body_class

      def set_body_class
        @body_class = 'bluegamma'
      end

      def index

        @result = BookPage.sphinx_search(params)

      end

      def export

        filename = 'export-' + DateTime.now.strftime('%Y%m%d%H%M%S%6N') + '.zip'
        temp_file = Tempfile.new(filename)

        begin
          BookPage.zip_for_search(params, temp_file)
          #send_file temp_file.path, type: 'application/zip', disposition: 'attachment', filename: filename
          send_data File.read(temp_file.path), type: 'application/zip', disposition: 'attachment', filename: filename
        ensure
          temp_file.close
          temp_file.unlink
        end

      end

    end
  end
end