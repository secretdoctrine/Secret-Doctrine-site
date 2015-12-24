class CreateLibraryPages < ActiveRecord::Migration
  def change
    create_table :library_pages do |t|

      t.integer     :book_id,         index:true, null:false
      t.decimal     :internal_order,  null:false
      t.string      :url_name,        null:false
      t.text        :page_text,       null:false

    end

    add_foreign_key :library_pages, :library_books, column: :book_id, on_delete: :cascade

  end
end
