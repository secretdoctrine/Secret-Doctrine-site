module Refinery
  module Authors
    module Admin
      class PoemsController < ::Refinery::AdminController

        before_action :find_all_authors

        crudify :'refinery/authors/poem',
                :title_attribute => 'title'

        private

        def find_all_authors
          @authors = Refinery::Authors::Author.all
        end

        # Only allow a trusted parameter "white list" through.
        def poem_params
          params.require(:poem).permit(:order, :content, :short_content, :picture_id, :author_id, :title)
        end
      end
    end
  end
end
