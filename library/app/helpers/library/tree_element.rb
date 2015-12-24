module Library
  class TreeElement

    attr_accessor :child_elements
    attr_accessor :controller
    attr_accessor :action
    attr_accessor :id
    attr_accessor :name
    attr_accessor :is_root
    attr_accessor :data_elements
    attr_accessor :is_open
    attr_accessor :tree_prefix

    def initialize(
        child_elements: [],
        data_elements: [],
        name: '',
        controller: '',
        action: '',
        id: 0,
        is_root: false,
        is_open: false,
        tree_prefix: nil
    )

      @child_elements = child_elements
      @data_elements = data_elements
      @name = name
      @controller = controller
      @action = action
      @id = id
      @is_root = is_root
      @is_open = is_open
      @tree_prefix = tree_prefix

    end

  end
end