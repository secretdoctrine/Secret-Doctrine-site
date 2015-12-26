module Library

  class CategoryContentElement

    attr_accessor :is_book
    attr_accessor :model

    def initialize(is_book: false, model: nil)

      @is_book = is_book
      @model = model

    end

  end

end