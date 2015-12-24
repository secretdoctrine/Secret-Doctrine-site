class CreateLibraryInternalPageContents < ActiveRecord::Migration
  def change
    create_table :library_internal_page_contents do |t|

      t.integer     :page_id,       index:true, null:false
      t.integer     :content_type,  null:false
      t.string      :content,       null:false

    end

    add_foreign_key :library_internal_page_contents, :library_pages, column: :page_id, on_delete: :cascade

  end
end
