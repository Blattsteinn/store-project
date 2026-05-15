class CreateFeedbacks < ActiveRecord::Migration[8.1]
  def change
    create_table :feedbacks do |t|
      t.timestamps

      t.references :user,     null: false,  foreign_key: true
      t.text       :feedback, null: false
      t.integer    :rating,  null: false, default: 5
      
    end
  end
end
