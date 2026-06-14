class AddDiscordToOrder < ActiveRecord::Migration[8.1]
  def change
    add_column :orders, :discord, :string, default: nil
  end
end
