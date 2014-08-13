class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.decimal :price, precision: 16, scale: 2

      t.timestamps
    end
  end
end
