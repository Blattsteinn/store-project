class CreateCartItems < ActiveRecord::Migration[8.1]
  def change
    create_table :cart_items do |t|
      t.timestamps

      t.references :product,  null: false, foreign_key: true
      t.references :user,     null: false, foreign_key: true
      t.integer    :quantity, null: false
    end
  end
end
