# This migration comes from refinery_authors (originally 2)
class CreateAuthorsPoems < ActiveRecord::Migration

  def up
    create_table :refinery_authors_poems do |t|
      t.integer :order
      t.string :title
      t.text :content
      t.text :short_content
      t.integer :picture_id
      t.integer :author_id
      t.integer :position

      t.timestamps
    end

  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-authors"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/authors/poems"})
    end

    drop_table :refinery_authors_poems

  end

end
