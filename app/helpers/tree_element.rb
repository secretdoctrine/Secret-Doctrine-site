class TreeElement

  attr_accessor :child_elements, :controller, :action, :id, :display_name, :is_root, :data_elements

  def initialize(child_elements: [], data_elements: [], display_name: '', controller: '', action: '', id: 0, is_root: false)

    @child_elements = child_elements
    @data_elements = data_elements
    @display_name = display_name
    @controller = controller
    @action = action
    @id = id
    @is_root = is_root

  end

end