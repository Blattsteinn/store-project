class Variant < ApplicationRecord
    belongs_to :product
    has_many :order_items
    has_many :wish_lists

    validates :stock, numericality: true
end
