class AddOrderNumberToMultimedia < ActiveRecord::Migration
  def change

    add_column :refinery_multimedia_groups, :order_number, :integer, :default => 0, :null => false
    add_column :refinery_multimedia_groups, :is_root, :boolean, :default => false, :null => false
    add_column :refinery_multimedia_groups_multimedia_items, :order_number, :integer, :default => 0, :null => false
    add_column :refinery_multimedia_groups_multimedia_items, :hidef_audio_file_id, :integer

  end
end
