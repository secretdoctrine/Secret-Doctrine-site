class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|

      t.references  :book,            indexes:true, foreign_key:true, null:true
      t.integer     :internal_order,  null:true
      t.string      :display_name,    null:true

    end
  end
end
