class Product < ApplicationRecord
    has_many :product_images, dependent: :destroy

    validates :deliverables,    presence: true
    validates :description,     presence: true
    validates :payment_type,    presence: true
    validates :pricing,         presence: true
    validates :stock,           presence: true
    validates :title,           presence: true
    validates :visibility,      presence: true

end
