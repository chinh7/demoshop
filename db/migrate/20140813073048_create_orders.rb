class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.belongs_to :user, index: true
      t.decimal :price, precision: 16, scale: 2
      t.integer :invoice_id
      t.text :invoice

      t.timestamps
    end
  end
end
