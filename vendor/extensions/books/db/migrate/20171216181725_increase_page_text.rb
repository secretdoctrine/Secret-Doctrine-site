class IncreasePageText < ActiveRecord::Migration
  def up
    change_column :refinery_books_book_pages, :page_text, :text, :limit => 16.megabytes - 1
  end

  def down

  end
end
