class CartItemsController < ApplicationController
    def create
        variant  = Variant.find(params[:variant_id])
        return if variant.stock < 1

        # Wanted quantity for the variant to add
        quantity = params[:quantity].to_i 

        session[:cart] ||= {}

        # Just checking if variant is stored in a session
        if session[:cart][variant.id.to_s].present?
            total = session[:cart][variant.id.to_s].to_i + quantity
        else
            total = params[:quantity].to_i 
        end
        
        # Checking if it has enough stock
        if variant.stock >= total
            if session[:cart][variant.id.to_s].present?
                session[:cart][variant.id.to_s] = total
            else
                session[:cart][variant.id.to_s] = quantity 
            end
        else
            # Not enough - render unsuccessful_add
            render turbo_stream: turbo_stream.replace("saved-message", 
            partial: "products/shared/unsuccessful_cart_add")
            return
        end

        respond_to do |format|
            # runs if request wants turbo_stream
            format.turbo_stream do
                render turbo_stream: [turbo_stream.replace(
                "cart-counter",
                partial: "carts/cart_counter",
                locals: { count: session[:cart].length }
                ),
                turbo_stream.replace("saved-message", partial: "products/shared/cart_add")]
            end
            # runs if request wants HTML (normal browser)
            format.html { redirect_to products_path, notice: "Added to cart" }
        end
    end

    def create_instantly
        session[:cart] = {}

        variant  = Variant.find(params[:variant_id])
        quantity = params[:quantity].to_i

        session[:cart][variant.id.to_s] = quantity unless quantity > variant.stock

        redirect_to orders_path, method: :post
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
