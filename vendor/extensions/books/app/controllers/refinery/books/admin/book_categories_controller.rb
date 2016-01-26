module Refinery
  module Books
    module Admin
      class BookCategoriesController < ::Refinery::AdminController

        crudify :'refinery/books/book_category',
                :title_attribute => 'name'

        private

        # Only allow a trusted parameter "white list" through.
        def book_category_params
          params.require(:book_category).permit(:book_category_id, :name, :is_root, :order_number, :synopsis)
        end
      end
    end
  end
end
