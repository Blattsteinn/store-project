class ChangeGameModel < ActiveRecord::Migration[8.1]
  def change
    rename_column :games, :game, :name
    add_column :games, :official_name, :string
  end
end
