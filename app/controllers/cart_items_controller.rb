class CartItemsController < ApplicationController
    def create
        variant  = Variant.find(params[:variant_id])
        quantity = params[:quantity].to_i

        return if variant.stock < 1

        session[:cart] ||= {}
        # Hash structure
        # variant_id => quantitiy,

        if session[:cart][variant.id.to_s].present?
            total = session[:cart][variant.id.to_s].to_i + quantity
            session[:cart][variant.id.to_s] = total unless total > variant.stock
        else
            session[:cart][variant.id.to_s] = quantity unless quantity > variant.stock
        end
        # redirect_to products_path, notice: "Added to cart"
        respond_to do |format|
            format.turbo_stream do
                render turbo_stream: turbo_stream.replace(
                "cart-counter",
                partial: "carts/cart_counter",
                locals: { count: session[:cart].length }
                )
            end
            format.html { redirect_to products_path, notice: "Added to cart" }
        end
    end

    def update
        variant = Variant.find(params[:variant_id])
        quantity = params[:quantity].to_i

        if quantity < 1 || quantity > variant.stock
            redirect_to cart_path
            return
        end

        session[:cart][params[:variant_id].to_s] = quantity

        respond_to do |format|
            format.turbo_stream do
                render turbo_stream: turbo_stream.replace(
                    "increase_variant_#{variant.id}",
                    # arba  ActionView::RecordIdentifier.dom_id(variant, :increase),
                    partial: "carts/cart_total",
                    locals: { quantity: quantity, variant: variant }
                )
            end
            format.html { redirect_to cart_path }
        end
    end

    def destroy
        session[:cart].delete(params[:variant_id].to_s)
        @variant = Variant.find(params[:variant_id])

        respond_to do |format|
            format.turbo_stream do
                 render turbo_stream: [
                    turbo_stream.remove("variant_#{@variant.id}"),
                    turbo_stream.replace(
                        "cart-counter",
                        partial: "carts/cart_counter",
                        locals: { count: session[:cart].length }
                    )
                ]
            end
            format.html { redirect_to cart_path }
        end
    end
end
