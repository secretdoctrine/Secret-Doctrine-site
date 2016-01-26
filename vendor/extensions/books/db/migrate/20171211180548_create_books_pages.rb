class CreateBooksPages < ActiveRecord::Migration
  def change
    create_table :refinery_books_book_pages do |t|

      t.integer     :book_id,         index:true, null:false
      t.decimal     :internal_order,  null:false
      t.string      :url_name,        null:false
      t.text        :page_text,       null:false

    end

    add_foreign_key :refinery_books_book_pages, :refinery_books, column: :book_id, on_delete: :cascade

  end
end
