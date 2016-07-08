class AddTreePrefixToBookCategories < ActiveRecord::Migration
  def change
    add_column :refinery_books_book_categories, :tree_prefix, :string
  end
end
