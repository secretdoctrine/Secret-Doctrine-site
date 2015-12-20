class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|

      t.references  :book,            index:true, foreign_key:true, null:false
      t.decimal     :internal_order,  null:false
      t.string      :url_name,        null:false
      t.text        :page_text,       null:false

    end
  end
end
