class Variant < ApplicationRecord
    belongs_to :product
    has_many :order_items

    validates :stock, numericality: true
end
