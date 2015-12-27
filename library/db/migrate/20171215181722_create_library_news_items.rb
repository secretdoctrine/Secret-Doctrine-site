class CreateLibraryNewsItems < ActiveRecord::Migration
  def change

    create_table :library_news_items do |t|

      t.text      :body,          :limit => 65535, :null => false
      t.boolean   :library_news,  :default => false, :null => false
      t.boolean   :site_news,     :default => false, :null => false
      t.datetime  :news_datetime, :null => false

    end

  end
end
