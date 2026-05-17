class CreateSupportMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :support_messages do |t|
      t.string :title
      t.string :email
      t.text :message
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
