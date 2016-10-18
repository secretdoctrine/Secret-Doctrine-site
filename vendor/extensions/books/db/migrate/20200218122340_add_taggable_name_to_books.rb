class AddTaggableNameToBooks < ActiveRecord::Migration
  def change
    add_column :refinery_books, :taggable_name, :string, :limit => 4096
  end
end
