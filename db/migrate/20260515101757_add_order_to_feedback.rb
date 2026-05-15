class AddOrderToFeedback < ActiveRecord::Migration[8.1]
  def change
    add_reference :feedbacks, :order, null: false, foreign_key: true
  end
end
