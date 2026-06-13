class MakeProductIdNullableInOrderItems < ActiveRecord::Migration[8.1]
  def change
    change_column_null :order_items, :product_id, true
  end
end
