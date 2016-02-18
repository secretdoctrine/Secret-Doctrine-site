class CreateFeedbackEntriesFeedbackEntries < ActiveRecord::Migration

  def up
    create_table :refinery_feedback_entries do |t|
      t.string :poster_name
      t.string :poster_email
      t.string :entry_title
      t.text :entry_text
      t.integer :position

      t.timestamps
    end

  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-feedback_entries"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/feedback_entries/feedback_entries"})
    end

    drop_table :refinery_feedback_entries

  end

end
