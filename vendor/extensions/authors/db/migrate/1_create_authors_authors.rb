class CreateAuthorsAuthors < ActiveRecord::Migration

  def up
    create_table :refinery_authors do |t|
      t.string :slug, :index => true
      t.string :friendly_header
      t.string :name
      t.string :poetry_header
      t.text :about_text
      t.integer :position

      t.timestamps
    end

  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-authors"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/authors/authors"})
    end

    drop_table :refinery_authors

  end

end
