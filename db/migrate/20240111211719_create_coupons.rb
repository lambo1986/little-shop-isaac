class CreateCoupons < ActiveRecord::Migration[7.0]
  def change
    create_table :coupons do |t|
      t.string :name
      t.string :code
      t.integer :percent_off
      t.integer :dollar_off
      t.bigint :merchant_id
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :coupons, :code, unique: true
    add_foreign_key :coupons, :merchants
  end
end
