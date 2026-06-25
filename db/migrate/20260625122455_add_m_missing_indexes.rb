class AddMMissingIndexes < ActiveRecord::Migration[8.1]
  def change
    add_index :orders, :status
    add_index :orders, :created_at
    add_index :products, :game_name
    add_index :products, :visibility
    add_index :games, :name, unique: true
    add_index :support_messages, :status
  end
end
