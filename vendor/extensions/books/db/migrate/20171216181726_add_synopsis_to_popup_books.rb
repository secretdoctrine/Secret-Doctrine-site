class AddSynopsisToPopupBooks < ActiveRecord::Migration
  def change
    add_column :refinery_books_popup_books, :synopsis, :text
  end
end
