class AddIsRootToAuthors < ActiveRecord::Migration
  def change
    add_column :refinery_authors, :is_root, :boolean, :default => false, :null => false, :index => true
    add_column :refinery_authors, :order_number, :integer, :default => 0, :null => false
    add_column :refinery_authors, :author_id, :integer
    add_column :refinery_authors_poems, :order_number, :integer, :default => 0, :null => false
    remove_column :refinery_authors_poems, :order, :integer
  end
end
