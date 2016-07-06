module Refinery
  module Books

    class CategoryContentElement

      attr_accessor :is_book
      attr_accessor :is_popup_book
      attr_accessor :model

      def initialize(is_book: false, model: nil, is_popup_book:false)

        @is_book = is_book
        @model = model
        @is_popup_book = is_popup_book

      end

    end

  end
end