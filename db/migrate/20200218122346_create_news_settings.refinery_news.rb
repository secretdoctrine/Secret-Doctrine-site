# This migration comes from refinery_news (originally 6)
class CreateNewsSettings < ActiveRecord::Migration

  def up

    create_table :refinery_news_settings do |t|
      t.integer :default_interval_in_months

      t.timestamps
    end

    ::Refinery::News::Setting.create!(default_interval_in_months: 3)

  end

  def down

    drop_table :refinery_news_settings

  end

end