class Order < ApplicationRecord
        validates :status, inclusion: { in: %w[pending paid processing delivered cancelled refunded] }

        belongs_to :user
        has_many :order_items, dependent: :destroy
        has_many :feedbacks
        has_many :support_messages

        #idk why tabs are 8 wide here
        def restore_stock!
            order_items.each { |item| item.variant.increment!(:stock, item.quantity) }
        end

        def paid?
            status == "paid"
        end
end
