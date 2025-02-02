class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price, precision: 10, scale: 2
      t.references :category, null: false, foreign_key: true
      t.integer :stock

      t.timestamps
    end
  end
end
