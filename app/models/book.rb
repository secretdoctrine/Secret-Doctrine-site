class Book < ActiveRecord::Base

  has_many :pages
  has_many :contents_elements
  belongs_to :book_category

  def add_contents_element(tree_parent, db_element)

    page = Page.find_by_book_id_and_internal_order(db_element.book.id, db_element.page_number)

    tree_element = ContentsTreeElement.new(
        display_name: db_element.name,
        book_id: db_element.book.id,
        page_internal_number: page ? page.url_name : nil,
        class_name: db_element.get_class_name,
        name_prefix: db_element.name_prefix,
        name_comment: db_element.name_comment
    )

    db_element.contents_elements.each { |x| add_contents_element(tree_element, x) }

    tree_parent.child_elements.push(tree_element)

  end

  def build_contents

    root_element = ContentsTreeElement.new

    contents_elements.where(contents_element_id: nil).sort_by{ |x| x.page_number }.each do |content_element|
      add_contents_element(root_element, content_element)
    end

    root_element

  end

  def get_parent_for_page(page_num)

    contents_elements.select{|x| x.page_number < page_num}.max_by{|x| x.page_number}

  end

end
