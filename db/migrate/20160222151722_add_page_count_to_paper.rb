class AddPageCountToPaper < ActiveRecord::Migration[5.0]
  def change
    add_column :papers, :page_count, :int
  end
end
