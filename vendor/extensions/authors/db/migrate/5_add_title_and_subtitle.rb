class AddTitleAndSubtitle < ActiveRecord::Migration
  def change

    add_column :refinery_authors, :title, :string
    add_column :refinery_authors, :subtitle, :string

  end
end
