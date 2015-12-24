class CreateLibraryBooks < ActiveRecord::Migration
  def change
    create_table :library_books do |t|

      t.string      :name,          null:false
      t.string      :name_prefix
      t.string      :tree_prefix
      t.string      :name_comment
      t.integer     :order_number,  null:false
      t.string      :picture_path
      t.string      :synopsis
      t.integer     :year
      t.string      :author
      t.integer     :page_count
      t.integer     :book_category_id, index:true

    end

    add_foreign_key :library_books, :library_book_categories, column: :book_category_id, on_delete: :cascade

  end
end
