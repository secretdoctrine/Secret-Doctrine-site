class AddHtmlClassNameToRefineryPages < ActiveRecord::Migration
  def change
    add_column :refinery_pages, :html_class_name, :string
  end
end
