# This migration comes from refinery_multimedia_groups (originally 1)
class CreateMultimediaGroupsMultimediaGroups < ActiveRecord::Migration

  def up
    create_table :refinery_multimedia_groups do |t|
      t.string :title
      t.integer :multimedia_group_id
      t.integer :position

      t.timestamps
    end

  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-multimedia_groups"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/multimedia_groups/multimedia_groups"})
    end

    drop_table :refinery_multimedia_groups

  end

end
