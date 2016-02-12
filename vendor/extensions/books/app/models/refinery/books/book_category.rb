module Refinery
  module Books
    class BookCategory < Refinery::Core::BaseModel

      belongs_to :book_category
      has_many :book_categories
      has_many :books

      ROOT_NAME = ::I18n.t('library.categories_root_name')

      def update_position(new_parent_id, old_parent_id, new_position, old_position)

        items_to_increase = []
        items_to_reduce = []

        new_parent = BookCategory.find(new_parent_id)
        old_parent = BookCategory.find(old_parent_id)

        if new_parent_id != old_parent_id

          items_to_increase = new_parent.book_categories.select{|x| x.order_number >= new_position}
          items_to_reduce = old_parent.book_categories.select{|x| x.order_number > old_position}

        else

          if new_position > old_position

            items_to_reduce = old_parent.book_categories.select{|x| x.order_number > old_position and x.order_number <= new_position}

          elsif new_position < old_position

            items_to_increase = old_parent.book_categories.select{|x| x.order_number >= new_position and x.order_number < old_position}

          end

        end

        ActiveRecord::Base.transaction do

          items_to_increase.each do |item|

            item.order_number += 1
            item.save

          end

          items_to_reduce.each do |item|

            item.order_number -= 1
            item.save

          end

          self.book_category_id = new_parent_id
          self.order_number = new_position

          save

        end

      end

      def get_next_order_number

        last_child = book_categories.sort_by{|x| x.order_number}.last

        return 0 if last_child.nil?
        last_child.order_number + 1

      end

      def self.get_root!

        root_category = find_by(name: ROOT_NAME)
        root_category = create!(name: ROOT_NAME, is_root: true, order_number: 0) if root_category.nil?
        root_category

      end

      def self.process_own_books(db_element, tree_element, selected_book_ids: [])

        db_element.books.each do |book|

          book_element = TreeElement.new(
              name: book.name,
              link_target: Refinery::Core::Engine.routes.url_helpers.books_book_path(book.id),
              id: book.id,
              tree_prefix: book.tree_prefix,
              is_data: true,
              order_number: book.order_number,
              selected: selected_book_ids.any?{ |x| x == book.id }
          )

          tree_element.child_elements.push(book_element)

        end

      end

      def self.add_tree_element(current_element, tree_parent, db_element, selected_book_ids: [], selected_category_ids: [])

        tree_element = TreeElement.new(
            name: db_element.name,
            link_target: Refinery::Core::Engine.routes.url_helpers.books_book_category_path(db_element.id),
            id: db_element.id,
            is_open: ((not current_element.nil?) and current_element.id == db_element.id ? true : false),
            order_number: db_element.order_number,
            selected: selected_category_ids.any?{|x| x == db_element.id}
        )

        process_own_books(db_element, tree_element, selected_book_ids: selected_book_ids)

        child_elements = db_element.book_categories.includes(:books)

        child_elements.each do |child|
          add_tree_element(
              current_element,
              tree_element,
              child,
              selected_book_ids: selected_book_ids,
              selected_category_ids: selected_category_ids
          )
        end


        tree_element.child_elements.sort_by!{|x| x.order_number}

        tree_parent.child_elements.push(tree_element)

      end



      def self.build_categories_tree_for_book(book)

        build_categories_tree(current_element: book.nil? ? nil : book.book_category)

      end

      def self.build_categories_tree(current_element: nil, selected_book_ids: [], selected_category_ids: [])

        root = includes(book_categories: [:books], books: []).find_by(name: ROOT_NAME)

        return TreeElement.new(is_root: true) if root.nil?

        root_element = TreeElement.new(
            is_root: true,
            link_target: Refinery::Core::Engine.routes.url_helpers.books_book_categories_path,
            name: root.name,
            selected: selected_category_ids.any?{|x| x == root.id}
        )

        root.book_categories.each do |child_category|
            self.add_tree_element(
                current_element,
                root_element,
                child_category,
                selected_book_ids: selected_book_ids,
                selected_category_ids: selected_category_ids)
        end

        process_own_books(root, root_element, selected_book_ids: selected_book_ids)

        root_element.child_elements.sort_by!{|x| x.order_number}

        root_element

      end

      def add_tree_element_to_choose_parent(tree_parent, db_element)

        return if db_element.id == id

        tree_element = TreeElement.new(
            name: db_element.name,
            id: db_element.id,
            is_open: (book_category and book_category.id == db_element.id),
            order_number: db_element.order_number,
            selected: (book_category and book_category.id == db_element.id)
        )

        child_elements = db_element.book_categories

        child_elements.each do |child|
          add_tree_element(
              tree_element,
              child
          )
        end

        tree_element.child_elements.sort_by!{|x| x.order_number}
        tree_parent.child_elements.push(tree_element)

      end

      def categories_tree_to_choose_parent

        root = BookCategory.includes(:book_categories).find_by(name: ROOT_NAME)
        return TreeElement.new(is_root: true) if root.nil?

        root_element = TreeElement.new(
            is_root: true,
            link_target: Refinery::Core::Engine.routes.url_helpers.books_book_categories_path,
            name: root.name,
            id: root.id,
            selected: (book_category and book_category.id == root.id)
        )

        root.book_categories.each do |child_category|
          add_tree_element_to_choose_parent(root_element, child_category)
        end

        root_element.child_elements.sort_by!{|x| x.order_number}

        root_element

      end


      def self.recursive_books_for_category(category)

        array = []
        category.books.sort{|x, y| x.order_number <=> y.order_number}.each{ |x| array.push(x) }

        category.book_categories.includes(:books).each do |child_category|
          array.concat(recursive_books_for_category(child_category))
        end

        array

      end

      def recursive_books_array

        self.class.recursive_books_for_category(self)

      end

      def category_content

        content = []
        books.each {|x| content.push(CategoryContentElement.new(is_book: true, model: x))}
        book_categories.each {|x| content.push(CategoryContentElement.new(is_book: false, model: x))}
        content.sort_by!{|x| x.model.order_number}

        content

      end

      def self.recursive_categories_array(array, category)

        array.push(category.id)
        category.book_categories.each {|x| recursive_categories_array(array, x)}

      end

      def categories_array

        array = []
        BookCategory.recursive_categories_array(array, self)
        array

      end

      def self.categories_for_select_recursive(array, category, nest_level)

        array.push(['-'*nest_level + category.name, category.id])
        category.book_categories.each {|x| categories_for_select_recursive(array, x, nest_level + 1)}

      end

      def self.categories_for_select

        root = get_root!
        array = []
        categories_for_select_recursive(array, root, 0)
        array

      end

    end
  end
end