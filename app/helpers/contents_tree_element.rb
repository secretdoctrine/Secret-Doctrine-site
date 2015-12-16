class ContentsTreeElement

  attr_accessor :child_elements
  attr_accessor :display_name
  attr_accessor :book_id
  attr_accessor :page_internal_number
  attr_accessor :is_open
  attr_accessor :class_name
  attr_accessor :name_prefix
  attr_accessor :name_comment

  def initialize(
      child_elements: [],
      display_name: '',
      book_id: 0,
      page_internal_number: 0,
      is_open: false,
      class_name: '',
      name_prefix: nil,
      name_comment: nil
  )

    @child_elements = child_elements
    @display_name = display_name
    @book_id = book_id
    @page_internal_number = page_internal_number
    @is_open = is_open
    @class_name = class_name
    @name_prefix = name_prefix
    @name_comment = name_comment

  end

end