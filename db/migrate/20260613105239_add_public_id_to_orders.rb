class AddPublicIdToOrders < ActiveRecord::Migration[8.1]
  def change
    add_column :orders, :public_id, :string
    add_index :orders, :public_id, unique: true
  end
end
