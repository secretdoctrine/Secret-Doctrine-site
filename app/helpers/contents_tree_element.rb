class ContentsTreeElement

  attr_accessor :child_elements, :display_name, :book_id, :page_internal_number, :is_open, :class_name

  def initialize(child_elements: [], display_name: '', book_id: 0, page_internal_number: 0, is_open: false, class_name: '')

    @child_elements = child_elements
    @display_name = display_name
    @book_id = book_id
    @page_internal_number = page_internal_number
    @is_open = is_open
    @class_name = class_name

  end

end