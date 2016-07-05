class AddPageFormatToRefineryBooks < ActiveRecord::Migration
  def change
    add_column :refinery_books, :page_format, :integer, :default => Refinery::Books::Book::FORMAT_700_950, :null => false
  end
end
