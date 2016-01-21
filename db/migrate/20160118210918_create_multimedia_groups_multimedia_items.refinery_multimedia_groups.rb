# This migration comes from refinery_multimedia_groups (originally 2)
class CreateMultimediaGroupsMultimediaItems < ActiveRecord::Migration

  def up
    create_table :refinery_multimedia_groups_multimedia_items do |t|
      t.integer :audio_file_id
      t.string :title
      t.string :video_link
      t.string :book_link
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
      ::Refinery::Page.delete_all({:link_url => "/multimedia_groups/multimedia_items"})
    end

    drop_table :refinery_multimedia_groups_multimedia_items

  end

end
