class CreateLibraryLinks < ActiveRecord::Migration

  def change
    create_table :refinery_books_library_links do |t|

      t.string    :name,              null:false
      t.string    :name_prefix
      t.string    :tree_prefix
      t.string    :name_comment
      t.integer   :order_number,      null:false
      t.integer   :book_category_id,  index:true
      t.integer   :position
      t.text      :link,          :limit => 65535
      t.text      :synopsis,      :limit => 65535
      t.integer   :cover_picture_id

      t.timestamps

    end

    add_foreign_key :refinery_books_library_links, :refinery_books_book_categories, column: :book_category_id, on_delete: :cascade

  end

end