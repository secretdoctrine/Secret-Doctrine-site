class CreateContentsElements < ActiveRecord::Migration
  def change
    create_table :contents_elements do |t|

      t.references  :book,              index:true, foreign_key:true, null:false
      t.references  :contents_element,  index:true, foreign_key:true, null:true
      t.integer     :page_number,       null:false
      t.string      :name_prefix
      t.string      :name,              null:false
      t.string      :name_comment
      t.integer     :ce_type,           null:false

    end
  end
end
