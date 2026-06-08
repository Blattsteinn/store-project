require "stripe"

class OrdersController < ApplicationController
    # pending, paid, processing, delivered, cancelled, refunded.
    before_action :authenticate_admin!, only: [ :update, :destroy ]
    before_action :authenticate_user!, only: [:index, :show]

    # -------------------------------------------------------------------
    # --- Only for Users who are signed in ------------------------------
    def index
        @orders = Order.where(user_id: current_user.id)
    end

    def show
        @order = current_user.orders.includes(order_items: [:product, :variant]).find(params[:id])
    end
    # -------------------------------------------------------------------
    # -------------------------------------------------------------------


    def create

        unless params[:email].present? && params[:variant_id].present? && params[:quantity].present?
            redirect_to products_path, alert: "Wrong inputs"
            return  
        end

        @email = params[:email]
        @variant = Variant.find(params[:variant_id].to_i)
        @quantity = params[:quantity].to_i

        # --- Checking the stock ---
        if @variant.stock < @quantity
            redirect_to product_path(Product.find_by(variant_id: @variant)), alert: "Not enough stock available"
            return  
        end

        ActiveRecord::Base.transaction do
            @order = Order.create!(email: @email)
            OrderItem.create!(
                order_id: @order.id,
                product_id: @variant.product_id,
                variant_id: @variant.id,
                quantity: @quantity,
                price: @variant.price
            )
        end

        # --- Set-up for Stripe ---
        line_items = @order.order_items.map do |item|
        {   quantity: item.quantity,
            price_data: { currency: "eur", unit_amount: item.price,
                        product_data: { name: item.product.title + " (#{item.variant.title })"} } }
        end

        # === Stripe session thing ===
        stripe_session = Stripe::Checkout::Session.create(
        mode: "payment",
        line_items: line_items,
        customer_email: @email,
        client_reference_id: @order.id.to_s,
        success_url: products_url(stripe: "success"),
        cancel_url: cancel_stripe_checkout_order_url(@order)
        )

        @order.update!(stripe_session_id: stripe_session.id)
        redirect_to stripe_session.url, allow_other_host: true

        rescue Stripe::StripeError => e
            @order&.destroy
            redirect_to cart_path, alert: "Payment could not be initiated: #{e.message}"

    end

    def cancel_stripe_checkout
        @order = Order.find(params[:id])
        if @order.status == "cancelled"
            @order.restore_stock!
            @order.destroy
            redirect_to cart_path, notice: "Checkout cancelled. Your cart has been restored."
        else
            redirect_to order_path(@order), alert: "This order cannot be cancelled."
        end
    end

    # Admin methods
    def update
        @order = Order.find(params[:id])
        @order.update!(order_params)
        redirect_to dashboard_order_path(@order)
    end


    def destroy
        @order = Order.find(params[:id])
        @order.destroy
        redirect_to dashboard_orders_path
    end

    private
    def order_params
        params.expect(order: [ :status ])
    end
end
