class RemovePriceStockFromProduct < ActiveRecord::Migration[8.1]
  def change
    remove_column :products, :stock, :integer
    remove_column :products, :pricing, :integer
  end
end
