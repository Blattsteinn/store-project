class CreateWishLists < ActiveRecord::Migration[8.1]
  def change
    create_table :wish_lists do |t|
      t.timestamps
    end
  end
end
