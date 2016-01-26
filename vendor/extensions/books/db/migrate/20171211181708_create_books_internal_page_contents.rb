class CreateBooksInternalPageContents < ActiveRecord::Migration
  def change

    create_table :refinery_books_internal_page_contents do |t|

      t.integer     :book_page_id,  index:true, null:false
      t.integer     :content_type,  null:false
      t.string      :content,       null:false

    end

    add_foreign_key :refinery_books_internal_page_contents, :refinery_books_book_pages, column: :book_page_id, on_delete: :cascade

  end
end
