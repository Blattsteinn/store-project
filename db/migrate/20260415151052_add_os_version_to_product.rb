class AddOsVersionToProduct < ActiveRecord::Migration[8.1]
  def change
    add_column :products, :ios_stock, :integer, default: 0
    add_column :products, :android_stock, :integer, default: 0
  end
end
