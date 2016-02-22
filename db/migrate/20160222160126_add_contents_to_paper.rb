class AddContentsToPaper < ActiveRecord::Migration[5.0]
  def change
    add_column :papers, :contents, :text
  end
end
