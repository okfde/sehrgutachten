class AddDoctypeToPaper < ActiveRecord::Migration[5.0]
  def change
    add_column :papers, :doctype, :string
  end
end
