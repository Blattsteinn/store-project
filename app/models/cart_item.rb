class CartItem < ApplicationRecord
    belongs_to :product
    belongs_to :user

    #["id", "created_at", "updated_at", "product_id", "user_id", "quantity"]
    validates :quantity, numericality: { greater_than: 0 }
    validate :sufficient_stock

    private 
    def sufficient_stock
        if product.stock < quantity 
            errors.add(:quantity, "Not enough stock")
        end
    end
end
