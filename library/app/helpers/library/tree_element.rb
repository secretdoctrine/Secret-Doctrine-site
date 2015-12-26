module Library
  class TreeElement

    attr_accessor :child_elements
    attr_accessor :controller
    attr_accessor :action
    attr_accessor :id
    attr_accessor :name
    attr_accessor :is_root
    attr_accessor :is_open
    attr_accessor :tree_prefix
    attr_accessor :is_data
    attr_accessor :order_number
    attr_accessor :selected

    BOOK_TYPE = 'book'
    CATEGORY_TYPE = 'category'

    def type
      is_data ? BOOK_TYPE : CATEGORY_TYPE
    end

    def initialize(
        child_elements: [],
        is_data: false,
        name: '',
        controller: '',
        action: '',
        id: 0,
        is_root: false,
        is_open: false,
        tree_prefix: nil,
        order_number: 0,
        selected: false
    )

      @selected = selected
      @child_elements = child_elements
      @is_data = is_data
      @name = name
      @controller = controller
      @action = action
      @id = id
      @is_root = is_root
      @is_open = is_open
      @tree_prefix = tree_prefix
      @order_number = order_number

    end

  end
end