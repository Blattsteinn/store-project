class WishList < ApplicationRecord
    after_create_commit { PurchaseSuccessMailer.successful_purchase(Order.first).deliver_later }
    belongs_to :variant
    belongs_to :user

    validates :variant,     presence: true
    validates :user,        presence: true
    validates :quantity,    presence: true, numericality: {greater_than: 0}
end
