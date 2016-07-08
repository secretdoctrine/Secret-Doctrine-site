class AddIsHiddenToBookCategories < ActiveRecord::Migration
  def change
    add_column :refinery_books_book_categories, :is_hidden, :boolean
  end
end
