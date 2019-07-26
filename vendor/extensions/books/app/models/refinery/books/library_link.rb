module Refinery
  module Books
    class LibraryLink < Refinery::Core::BaseModel

      belongs_to :cover_picture, :class_name => '::Refinery::Image'

      SHORT_NAME_LIMIT = 80

      def short_name
        return name if name.length < SHORT_NAME_LIMIT
        name.first(SHORT_NAME_LIMIT) + '(...)'
      end

      def parent_id=(new_id)
        self.book_category_id = new_id
      end

      self.table_name = 'refinery_books_library_links'

      validates :name, :presence => true#, :uniqueness => true

      belongs_to :book_category

      def update_position(new_parent_id, old_parent_id, new_position, old_position)

        OrderableHelper.process_orderable(self, new_parent_id, old_parent_id, new_position, old_position, BookCategory)

      end

    end
  end
end
