class RemoveContentElementNameLimit < ActiveRecord::Migration
  def change
    change_column :refinery_books_contents_elements, :name, :string, :limit => 4096
    change_column :refinery_books_contents_elements, :name_prefix, :string, :limit => 1024
    change_column :refinery_books_contents_elements, :name_comment, :string, :limit => 1024
  end
end
