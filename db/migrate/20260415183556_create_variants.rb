class CreateVariants < ActiveRecord::Migration[8.1]
  def change
    create_table :variants do |t|
      t.timestamps
      t.references :product, foreign_key: true, null: false

      t.integer    :stock,       null: false, default: 0
      t.integer    :price,       null: false, default: 0
      t.string     :title,       null: false, default: "Variant title"
      t.string     :description, null: false, default: "-"
    end
  end
end
