class RestoreStockColumn < ActiveRecord::Migration[8.1]
  def change
    add_column :products, :stock, :integer, null: false, default: 0
    remove_column :products, :ios_stock, :integer
    remove_column :products, :android_stock, :integer
  end
end
