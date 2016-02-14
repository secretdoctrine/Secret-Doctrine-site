class CreateBooksBooks < ActiveRecord::Migration

  def up
    create_table :refinery_books do |t|

      t.string    :name,              null:false
      t.string    :name_prefix
      t.string    :tree_prefix
      t.string    :name_comment
      t.integer   :order_number,      null:false
      t.integer   :cover_picture_id
      t.integer   :book_file_id
      #t.string    :picture_path
      t.text      :synopsis
      t.integer   :year
      t.string    :author
      t.integer   :page_count
      t.boolean   :can_buy,           null:false, default:false
      t.integer   :book_category_id,  index:true
      t.integer   :position

      t.timestamps

    end

    add_foreign_key :refinery_books, :refinery_books_book_categories, column: :book_category_id, on_delete: :cascade

  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-books"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/books/books"})
    end

    #remove_foreign_key :refinery_books, :refinery_books_book_categories
    drop_table :refinery_books

  end

end
