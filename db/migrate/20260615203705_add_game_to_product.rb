class AddGameToProduct < ActiveRecord::Migration[8.1]
  def change
    add_column :products, :game_name, :string
  end
end
