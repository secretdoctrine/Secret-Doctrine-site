module Refinery
  module Authors
    class Poem < Refinery::Core::BaseModel

      belongs_to :author

      validates :content, :presence => true

      belongs_to :picture, :class_name => '::Refinery::Image'
      belongs_to :tile_picture, :class_name => '::Refinery::Image'
      belongs_to :preview_picture, :class_name => '::Refinery::Image'

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]

      SHORT_NAME_LIMIT = 80

      def short_title
        return title if title.length < SHORT_NAME_LIMIT
        title.first(SHORT_NAME_LIMIT) + '(...)'
      end

      def parent_id=(new_id)
        self.author_id = new_id
      end

      def update_position(new_parent_id, old_parent_id, new_position, old_position)

        Refinery::Books::OrderableHelper.process_orderable(self, new_parent_id, old_parent_id, new_position, old_position, Author)

      end

      def has_next_poem?
        !next_poem.nil?
      end

      def next_poem

        author.poems.sort_by{|x| x.order_number}.select{|x| x.order_number > order_number}.first

      end

      def has_prev_poem?
        !prev_poem.nil?
      end

      def prev_poem

        author.poems.sort_by{|x| x.order_number}.select{|x| x.order_number < order_number}.last

      end

    end
  end
end
