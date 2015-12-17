class Book < ActiveRecord::Base

  has_many :pages
  has_many :contents_elements
  belongs_to :book_category

  def add_contents_element(tree_parent, db_element, page)

    parent_for_page = page ? get_parent_for_page(page.internal_order) : nil
    target_page = Page.find_by_book_id_and_internal_order(db_element.book.id, db_element.page_number)

    tree_element = ContentsTreeElement.new(
        selected: (parent_for_page and parent_for_page.id == db_element.id),
        display_name: db_element.name,
        book_id: db_element.book.id,
        page_internal_number: target_page ? target_page.url_name : nil,
        class_name: db_element.get_class_name,
        name_prefix: db_element.name_prefix,
        name_comment: db_element.name_comment
    )

    db_element.contents_elements.each { |x| add_contents_element(tree_element, x, page) }

    tree_parent.child_elements.push(tree_element)

  end

  def build_contents(page)

    root_element = ContentsTreeElement.new

    contents_elements.where(contents_element_id: nil).sort_by{ |x| x.page_number }.each do |content_element|
      add_contents_element(root_element, content_element, page)
    end

    root_element

  end

  def get_parent_for_page(page_num)

    preceding_elements = contents_elements.select{|x| x.page_number <= page_num}
    return nil if preceding_elements.empty?
    max_named_page = preceding_elements.max_by{|x| x.page_number}.page_number

    element = contents_elements.select{|x| x.page_number == max_named_page}.sort_by{|x| -x.get_nest_level}.first

  end

end
