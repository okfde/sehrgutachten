class AddDownloadedAtToPaper < ActiveRecord::Migration[5.0]
  def change
    add_column :papers, :downloaded_at, :datetime
  end
end
