module Refinery
  module Books
    class BaseController < ::ApplicationController#ActionController::Base

      def render_404
        page_not_found
      end

    end
  end
end
