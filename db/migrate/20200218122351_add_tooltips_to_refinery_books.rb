class AddTooltipsToRefineryBooks < ActiveRecord::Migration
  def change
    add_column :refinery_books, :tree_prefix_tooltip, :string, :limit => 4096
    add_column :refinery_books, :name_tooltip, :string, :limit => 4096

    add_column :refinery_books_library_links, :tree_prefix_tooltip, :string, :limit => 4096
    add_column :refinery_books_library_links, :name_tooltip, :string, :limit => 4096

    add_column :refinery_books_popup_books, :tree_prefix_tooltip, :string, :limit => 4096
    add_column :refinery_books_popup_books, :name_tooltip, :string, :limit => 4096
  end
end
