class Variant < ApplicationRecord
    belongs_to :product
    has_many :order_items, dependent: :nullify
    has_many :wish_lists, dependent: :destroy

    validates :stock, numericality: true
end
