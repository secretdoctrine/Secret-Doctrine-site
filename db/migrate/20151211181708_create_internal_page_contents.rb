class CreateInternalPageContents < ActiveRecord::Migration
  def change
    create_table :internal_page_contents do |t|

      t.references  :page,    index:true, foreign_key:true, null:false
      t.integer     :type,    null:false
      t.string      :content, null:false

    end
  end
end
