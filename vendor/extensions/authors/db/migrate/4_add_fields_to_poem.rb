class AddFieldsToPoem < ActiveRecord::Migration
  def change

    add_column :refinery_authors_poems, :tile_picture_id, :integer
    add_column :refinery_authors_poems, :preview_picture_id, :integer

    add_column :refinery_authors_poems, :name_second_line, :string
    add_column :refinery_authors_poems, :name_comment, :text
    add_column :refinery_authors_poems, :alt_top_block, :text

  end
end
