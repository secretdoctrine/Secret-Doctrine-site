class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string  :name,          null:false
      t.integer :order_number,  null:false

    end
  end
end
