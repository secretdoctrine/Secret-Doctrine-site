class CreateLibraryExternalBookContent < ActiveRecord::Migration
  def change
    create_table :library_external_book_contents do |t|

      t.integer     :book_id,         index:true, null:false
      t.integer     :content_type,    null:false
      t.string      :path,            null:false

    end

    add_foreign_key :library_external_book_contents, :library_books, column: :book_id, on_delete: :cascade

  end
end
