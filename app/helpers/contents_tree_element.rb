class ContentsTreeElement

  attr_accessor :child_elements, :display_name, :book_id, :page_internal_number, :is_open

  def initialize(child_elements: [], display_name: '', book_id: 0, page_internal_number: 0, is_open: false)

    @child_elements = child_elements
    @display_name = display_name
    @book_id = book_id
    @page_internal_number = page_internal_number
    @is_open = is_open

  end

end