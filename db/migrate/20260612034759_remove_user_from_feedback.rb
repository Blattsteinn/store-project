class RemoveUserFromFeedback < ActiveRecord::Migration[8.1]
  def change
    remove_column :feedbacks, :user_id, :integer
  end
end
