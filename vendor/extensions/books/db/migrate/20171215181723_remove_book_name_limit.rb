class RemoveBookNameLimit < ActiveRecord::Migration
  def change
    change_column :refinery_books, :name, :string, :limit => 4096
    change_column :refinery_books, :name_prefix, :string, :limit => 1024
    change_column :refinery_books, :name_comment, :string, :limit => 1024
  end
end
