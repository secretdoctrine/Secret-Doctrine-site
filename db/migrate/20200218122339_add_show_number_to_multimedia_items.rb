class AddShowNumberToMultimediaItems < ActiveRecord::Migration
  def change

    add_column :refinery_multimedia_groups_multimedia_items, :show_number, :boolean, :default => true, :null => false

  end
end
