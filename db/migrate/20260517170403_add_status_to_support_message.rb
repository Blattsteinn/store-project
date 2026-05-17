class AddStatusToSupportMessage < ActiveRecord::Migration[8.1]
  def change
    add_column :support_messages, :status, :string, default: "open"
  end
end
