class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.timestamps
      t.string      :title,        null: false
      t.string      :visibility,   null: false, default: "hidden"
      t.text        :description,  null: false
      t.integer     :pricing,      null: false

      t.string      :payment_type, null: false, default: "single_payment"
      t.string      :deliverables, null: false, default: "static_value"

      t.integer     :stock,        null: false, default: "0"

    end
  end
end
