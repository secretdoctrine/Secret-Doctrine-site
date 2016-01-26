class CreateBooksBookCategories < ActiveRecord::Migration

  def up
    create_table :refinery_books_book_categories do |t|

      t.integer   :book_category_id,  index:true
      t.string    :name,              null:false
      t.boolean   :is_root
      t.integer   :order_number,      null:false
      t.text      :synopsis
      t.integer   :position

      t.timestamps
    end

    add_foreign_key :refinery_books_book_categories, :refinery_books_book_categories, column: :book_category_id, on_delete: :cascade

  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-books"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/books/book_categories"})
    end

    remove_foreign_key :refinery_books_book_categories, column: :book_category_id
    drop_table :refinery_books_book_categories, column: :book_category_id

  end

end
