class CreateDepartments < ActiveRecord::Migration[5.0]
  def change
    create_table :departments do |t|
      t.string :short_name
      t.string :subject
      t.string :source_url
      t.string :slug

      t.timestamps

      t.index :slug, unique: true
    end
  end
end
