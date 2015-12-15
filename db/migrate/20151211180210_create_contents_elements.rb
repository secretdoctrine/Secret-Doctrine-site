class CreateContentsElements < ActiveRecord::Migration
  def change
    create_table :contents_elements do |t|

      t.references  :book,            indexes:true, foreign_key:true, null:false
      t.references  :content_element, indexes:true, foreign_key:true, null:true
      t.integer     :page_number,     null:false
      t.string      :name,            null:false

    end
  end
end
