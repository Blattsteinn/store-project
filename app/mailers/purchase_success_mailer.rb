class PurchaseSuccessMailer < ApplicationMailer
  def successful_purchase(order)
    @order = order
    @email = order.email
    mail(to: @email, subject: "Order #{@order.id} delivery")
  end
end
