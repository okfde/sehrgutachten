class AddSlugToPaper < ActiveRecord::Migration[5.0]
  def change
    add_column :papers, :slug, :string
  end
end
