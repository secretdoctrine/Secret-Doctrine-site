class CreateInternalPageContents < ActiveRecord::Migration
  def change
    create_table :internal_page_contents do |t|

      t.references  :page,          indexes:true, foreign_key:true, null:false
      t.integer     :content_type,  null:false
      t.string      :content,       null:false

    end
  end
end
