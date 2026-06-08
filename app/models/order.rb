class Order < ApplicationRecord
        validates :status, inclusion: { in: %w[pending paid processing delivered cancelled refunded] }

        # after_create_commit { PurchaseSuccess.successful_purchase(self).deliver_later }

        belongs_to :user, optional: true
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
