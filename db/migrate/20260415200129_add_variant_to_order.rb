class AddVariantToOrder < ActiveRecord::Migration[8.1]
  def change
    add_reference :order_items, :variant, foreign_key: true, null: true
  end
end
