class CreateExternalBookContent < ActiveRecord::Migration
  def change
    create_table :external_book_contents do |t|

      t.references  :book,            index:true, foreign_key:true, null:false
      t.integer     :content_type,    null:false
      t.string      :path,            null:false

    end
  end
end
