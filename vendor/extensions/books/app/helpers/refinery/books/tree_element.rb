module Refinery
  module Books
    class TreeElement

      attr_accessor :child_elements
      attr_accessor :link_target
      attr_accessor :name
      attr_accessor :is_root
      attr_accessor :is_open
      attr_accessor :tree_prefix
      attr_accessor :is_data
      attr_accessor :order_number
      attr_accessor :selected
      attr_accessor :id

      BOOK_TYPE = 'book'
      CATEGORY_TYPE = 'category'

      def type
        is_data ? BOOK_TYPE : CATEGORY_TYPE
      end

      def initialize(
          child_elements: [],
          is_data: false,
          name: '',
          link_target: nil,
          is_root: false,
          is_open: false,
          tree_prefix: nil,
          order_number: 0,
          selected: false,
          id: 0
      )

        @selected = selected
        @child_elements = child_elements
        @is_data = is_data
        @name = name
        @link_target = link_target
        @is_root = is_root
        @is_open = is_open
        @tree_prefix = tree_prefix
        @order_number = order_number
        @id = id

      end

    end
  end
end