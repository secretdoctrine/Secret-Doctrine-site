module Refinery
  module Authors
    module Admin
      class AuthorsController < ::Refinery::AdminController

        crudify :'refinery/authors/author',
                :title_attribute => 'name'

        private

        # Only allow a trusted parameter "white list" through.
        def author_params
          params.require(:author).permit(:name, :poetry_header, :about_text, :friendly_header)
        end
      end
    end
  end
end
