class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|

      t.string      :name,          null:false
      t.string      :name_prefix
      t.string      :tree_prefix
      t.string      :name_comment
      t.integer     :order_number,  null:false
      t.string      :picture_path
      t.string      :synopsis
      t.integer     :year
      t.string      :author
      t.integer     :page_count
      t.references  :book_category, index:true, foreign_key:true, null:false

    end
  end
end
