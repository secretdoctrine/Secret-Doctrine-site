module Refinery
  module Books
    module Admin
      class BooksController < ::Refinery::AdminController

        crudify :'refinery/books/book',
                :title_attribute => 'name'

        private

        # Only allow a trusted parameter "white list" through.
        def book_params
          params.require(:book).permit(:name, :name_prefix, :tree_prefix, :name_comment, :order_number, :picture_path_id, :synopsis, :year, :author, :page_count, :can_buy, :book_category_id)
        end
      end
    end
  end
end
