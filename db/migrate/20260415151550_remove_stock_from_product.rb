class RemoveStockFromProduct < ActiveRecord::Migration[8.1]
  def change
    remove_column :products, :stock, :integer
  end
end
