class AddExtendedNameToMultimediaGroups < ActiveRecord::Migration
  def change
    add_column :refinery_multimedia_groups, :extended_name, :text
  end
end
