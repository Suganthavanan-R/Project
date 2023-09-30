class CreateLineItems < ActiveRecord::Migration[6.1]
  def change
    create_table :line_items do |t|
      t.string :product_name
      t.integer :product_id
      t.integer :quantity
      t.decimal :unit_price
      t.decimal :purchased_price
      t.decimal :tax
      t.decimal :tax_pay
      t.decimal :total

      t.timestamps
    end
  end
end
