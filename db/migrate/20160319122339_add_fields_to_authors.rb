class AddFieldsToAuthors < ActiveRecord::Migration
  def change
    #add_column :refinery_authors_poems, :order_number, :integer, :default => 0, :null => false
    add_column :refinery_authors, :additional_info, :text
    add_column :refinery_authors, :last_poem_placeholder, :text
    add_column :refinery_authors, :need_placeholder, :boolean, :default => false, :null => false
    add_column :refinery_authors_poems, :image_caption, :text
  end
end
