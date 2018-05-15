class CreateNewsItemsNewsRecipients < ActiveRecord::Migration

  def up
    create_table :refinery_news_items_news_recipients do |t|
      t.string :email, :limit => 255
      t.string :name, :limit => 255
      t.string :city, :limit => 255

      t.timestamps
    end

  end

  def down

    drop_table :refinery_news_items_news_recipients

  end

end
