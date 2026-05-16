class CreateWishLists < ActiveRecord::Migration[8.1]
  def change
    create_table :wish_lists do |t|
      t.timestamps

      t.references :variant, foreign_key: true, null: false
      t.references :user,    foreign_key: true, null: false
      t.integer    :quantity, null: false, default: 1
    end
  end
end
