class CreateBooksContentsElements < ActiveRecord::Migration
  def change
    create_table :refinery_books_contents_elements do |t|

      t.integer     :book_id,              index:true, null:false
      t.integer     :contents_element_id,  index:true, null:true
      t.integer     :page_number,       null:false
      t.string      :name_prefix
      t.string      :name,              null:false
      t.string      :name_comment
      t.integer     :ce_type,           null:false

    end

    add_foreign_key :refinery_books_contents_elements, :refinery_books, column: :book_id, on_delete: :cascade
    add_foreign_key :refinery_books_contents_elements, :refinery_books_contents_elements, column: :contents_element_id, on_delete: :cascade

  end
end
