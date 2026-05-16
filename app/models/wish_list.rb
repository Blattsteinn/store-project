class WishList < ApplicationRecord
    belongs_to :variant
    belongs_to :user

    validates :variant,     presence: true
    validates :user,        presence: true
    validates :quantity,    presence: true, numericality: {greater_than: 0}
end
