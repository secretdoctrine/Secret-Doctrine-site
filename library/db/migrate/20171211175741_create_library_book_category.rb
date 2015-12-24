class CreateLibraryBookCategory < ActiveRecord::Migration
  def change

    create_table :library_book_categories do |t|

      t.integer     :book_category_id,  index:true
      t.string      :name,              null:false
      t.boolean     :is_root
      t.integer     :order_number,      null:false

    end

    add_foreign_key :library_book_categories, :library_book_categories, column: :book_category_id, on_delete: :cascade

  end
end
