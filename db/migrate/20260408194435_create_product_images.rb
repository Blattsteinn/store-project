class CreateProductImages < ActiveRecord::Migration[8.1]
  def change
    create_table :product_images do |t|
      t.timestamps

      t.references :product,  null: false, foreign_key: true
      t.string     :url,      null: false
      t.integer    :priority, null: false, default: 0


    end
  end
end
