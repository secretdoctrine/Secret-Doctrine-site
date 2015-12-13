class BookCategory < ActiveRecord::Base

  belongs_to :book_category
  has_many :book_categories
  has_many :books

  ROOT_NAME = 'root'

  def self.get_root!

    root_category = find_by(name: ROOT_NAME)
    root_category = create!(name: ROOT_NAME, is_root: true, order_number: 0) if root_category.nil?
    root_category

  end

  def self.process_own_books(db_element, tree_element)

    db_element.books.sort{ |x, y| x.order_number <=> y.order_number }.each do |book|

      book_element = TreeElement.new(display_name: book.name, controller: :books, action: :show, id: book.id)
      tree_element.data_elements.push(book_element)

    end

  end

  def self.add_tree_element(tree_parent, db_element)

    tree_element = TreeElement.new(display_name: db_element.name)

    process_own_books(db_element, tree_element)

    child_elements = db_element.book_categories.includes(:books)

    child_elements.sort{ |x, y| x.order_number <=> y.order_number }.each {
        |child| add_tree_element(tree_element, child)
    }

    tree_parent.child_elements.push(tree_element)

  end

  def self.build_categories_tree

    root = includes(book_categories: [:books], books: []).find_by(name: ROOT_NAME)
    root_element = TreeElement.new(is_root: true)

    root.book_categories.sort{ |x, y| x.order_number <=> y.order_number }.each {
        |child_category| add_tree_element(root_element, child_category)
    }

    process_own_books(root, root_element)

    root_element

  end

end