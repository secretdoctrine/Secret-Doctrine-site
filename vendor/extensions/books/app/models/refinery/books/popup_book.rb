module Refinery
  module Books
    class PopupBook < Refinery::Core::BaseModel

      self.table_name = 'refinery_books_popup_books'

      validates :name, :presence => true#, :uniqueness => true

      belongs_to :book_category

      SHORT_NAME_LIMIT = 80

      def short_name
        return name if name.length < SHORT_NAME_LIMIT
        name.first(SHORT_NAME_LIMIT) + '(...)'
      end

      def parent_id=(new_id)
        self.book_category_id = new_id
      end

      def update_position(new_parent_id, old_parent_id, new_position, old_position)

        OrderableHelper.process_orderable(self, new_parent_id, old_parent_id, new_position, old_position, BookCategory)

      end

    end
  end
end
