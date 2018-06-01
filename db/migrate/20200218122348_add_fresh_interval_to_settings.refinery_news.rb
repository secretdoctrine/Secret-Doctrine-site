# This migration comes from refinery_news (originally 7)
class AddFreshIntervalToSettings < ActiveRecord::Migration

  def change

    add_column :refinery_news_settings, :fresh_interval_in_months, :integer, :null => false, :default => 1

  end

end