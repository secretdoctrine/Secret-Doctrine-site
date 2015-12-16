class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|

      t.references  :book,            index:true, foreign_key:true, null:false
      t.integer     :internal_order,  null:false
      t.string      :display_name,    index:true
      t.string      :url_name,        null:false

    end
  end
end
