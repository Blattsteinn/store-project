class DropAdminsTable < ActiveRecord::Migration[8.1]
  def change
    drop_table :admins if table_exists?(:admins)
  end
end
