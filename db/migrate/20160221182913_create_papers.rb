class CreatePapers < ActiveRecord::Migration[5.0]
  def change
    create_table :papers do |t|
      t.string :reference
      t.string :title
      t.string :url
      t.references :department, index: true, foreign_key: true
      t.datetime :created_at


      t.timestamps
    end
  end
end
