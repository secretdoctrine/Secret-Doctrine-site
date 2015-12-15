class CreateBookCategory < ActiveRecord::Migration
  def change

    create_table :book_categories do |t|

      t.references  :book_category,   index:true, foreign_key:true
      t.string      :name,            null:false
      t.boolean     :is_root
      t.integer     :order_number,    null:false

    end

  end
end
