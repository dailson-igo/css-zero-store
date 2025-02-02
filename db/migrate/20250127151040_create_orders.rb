class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.string :status
      t.datetime :order_date
      t.references :customer, null: false, foreign_key: true
      t.decimal :total_amount, precision: 10, scale: 2

      t.timestamps
    end
  end
end
