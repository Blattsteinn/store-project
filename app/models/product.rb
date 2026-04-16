class Product < ApplicationRecord
    has_many :product_images, dependent: :destroy
    accepts_nested_attributes_for :product_images, allow_destroy: true,
    reject_if: ->(attrs) { attrs["image"].blank? }

    has_many :cart_items, dependent: :destroy
    has_many :order_items, dependent: :restrict_with_error #OK, cool. Can't delete if it has an association.
    
    has_many :variants, dependent: :destroy
    accepts_nested_attributes_for :variants, allow_destroy: true, reject_if: :all_blank

    validates :deliverables,    presence: true
    validates :description,     presence: true
    validates :payment_type,    presence: true
    validates :title,           presence: true
    validates :visibility,      presence: true

end
