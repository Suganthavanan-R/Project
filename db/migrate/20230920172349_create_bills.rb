class CreateBills < ActiveRecord::Migration[6.1]
  def change
    create_table :bills do |t|
      t.string :customer_email
      t.decimal :total_price
      t.decimal :total_tax_payable
      t.decimal :net_price
      t.decimal :rounded_down_value
      t.decimal :balance_payable_to_customer

      t.timestamps
    end
  end
end
