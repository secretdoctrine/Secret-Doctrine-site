class CreateContentsElements < ActiveRecord::Migration
  def change
    create_table :contents_elements do |t|

      t.references  :book,        index:true, foreign_key:true, null:false
      t.integer     :page_number, null:false

    end
  end
end
