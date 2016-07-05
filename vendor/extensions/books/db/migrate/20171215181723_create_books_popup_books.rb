def change
  create_table :refinery_books_popup_books do |t|

    t.string    :name,              null:false
    t.string    :name_prefix
    t.string    :tree_prefix
    t.string    :name_comment
    t.integer   :order_number,      null:false
    t.integer   :book_category_id,  index:true
    t.integer   :position
    t.text      :body,          :limit => 65535

    t.timestamps

  end

  add_foreign_key :refinery_books_popup_books, :refinery_books_book_categories, column: :book_category_id, on_delete: :cascade

end