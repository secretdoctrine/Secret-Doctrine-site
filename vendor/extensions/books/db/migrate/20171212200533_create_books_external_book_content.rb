class CreateBooksExternalBookContent < ActiveRecord::Migration
  def change
    create_table :refinery_books_external_book_contents do |t|

      t.integer     :book_id,         index:true, null:false
      t.integer     :content_type,    null:false
      t.string      :path,            null:false

    end

    add_foreign_key :refinery_books_external_book_contents, :refinery_books, column: :book_id, on_delete: :cascade

  end
end
