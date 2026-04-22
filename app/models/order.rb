class Order < ApplicationRecord
        validates :status, inclusion: { in: %w[pending paid processing delivered cancelled refunded] }

        belongs_to :user
        has_many :order_items, dependent: :destroy
end
