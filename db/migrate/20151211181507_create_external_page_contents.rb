class CreateExternalPageContents < ActiveRecord::Migration
  def change
    create_table :external_page_contents do |t|

      t.references  :page, index:true, foreign_key:true, null:false
      t.integer     :type, null:false
      t.string      :path, null:false

    end
  end
end
