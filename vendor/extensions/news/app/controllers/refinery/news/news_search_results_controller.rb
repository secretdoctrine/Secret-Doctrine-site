module Refinery
  module News
    class NewsSearchResultsController < ::ApplicationController

      before_action :set_body_class, :set_page_title

      def set_body_class
        @body_class = 'bluegamma'
      end

      def set_page_title
        @page_title = t('headers.search')
      end

      def index

        #@result = BookPage.sphinx_search(params)
        #@page_title += t('headers.separator') + @result[:count].to_s + t('headers.results_found')
        @result = NewsItem.sphinx_search(params)

      end

    end
  end
end