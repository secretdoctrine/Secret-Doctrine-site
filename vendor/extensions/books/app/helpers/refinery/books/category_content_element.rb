module Refinery
  module Books

    class CategoryContentElement

      attr_accessor :is_book
      attr_accessor :is_popup_book
      attr_accessor :model
      attr_accessor :is_link

      def initialize(is_book: false, model: nil, is_popup_book:false, is_link:false)

        @is_book = is_book
        @model = model
        @is_popup_book = is_popup_book
        @is_link = is_link

      end

    end

  end
end