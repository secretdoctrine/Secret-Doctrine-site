module Refinery
  module Authors
    class Poem < Refinery::Core::BaseModel

      belongs_to :author

      validates :content, :presence => true, :uniqueness => true

      belongs_to :picture, :class_name => '::Refinery::Image'

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]

      def has_next_poem?
        !next_poem.nil?
      end

      def next_poem

        author.poems.sort_by{|x| x.order}.select{|x| x.order > order}.first

      end

      def has_prev_poem?
        !prev_poem.nil?
      end

      def prev_poem

        author.poems.sort_by{|x| x.order}.select{|x| x.order < order}.last

      end

    end
  end
end
