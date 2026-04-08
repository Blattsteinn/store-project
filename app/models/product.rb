class Product < ApplicationRecord
    has_many :product_images, dependent: :destroy
    has_many :cart_items, dependent: :destroy
    has_many :order_items, dependent: :restrict_with_error #OK, cool. Can't delete if it has an association.

    validates :deliverables,    presence: true
    validates :description,     presence: true
    validates :payment_type,    presence: true
    validates :pricing,         presence: true
    validates :stock,           presence: true
    validates :title,           presence: true
    validates :visibility,      presence: true

end
