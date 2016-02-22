class AddLastModifiedToPaper < ActiveRecord::Migration[5.0]
  def change
    add_column :papers, :last_modified, :datetime
  end
end
