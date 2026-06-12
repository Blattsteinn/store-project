class WishListsController < ApplicationController
    before_action :authenticate_admin!
    # Intended for later use.
    #
    def index
        @wish_lists = current_user.wish_lists.includes([variant: {product: {product_images: :image_attachment}}])
    end

    def create
        @wish_list = WishList.find_by(user_id: current_user.id, variant_id: params[:wish_list][:variant_id])
        variant = Variant.find(params[:wish_list][:variant_id])

        if params[:wish_list][:quantity].to_i > variant.stock
            render turbo_stream: turbo_stream.replace("saved-message", partial: "products/shared/unsuccessful_add")
            return
        end

        unless @wish_list.nil?
            quantity = @wish_list.quantity + params[:wish_list][:quantity].to_i

            # Rails.logger.debug "stock: #{variant.stock}, quantity: #{quantity}"
            # byebug

            if variant.stock >= quantity
                @wish_list.update!(quantity: quantity)

                render turbo_stream: [
                    turbo_stream.replace("saved-message", partial: "products/shared/successful_add"),
                    turbo_stream.replace("wishlist-counter", partial: "wish_lists/wish_list_counter")
                    ] 
            else
                render turbo_stream: turbo_stream.replace("saved-message", partial: "products/shared/unsuccessful_add")
            end
            return
        end

        @wish_list = WishList.new(wish_list_params)
        @wish_list.user_id = current_user.id

        if @wish_list.save
            render turbo_stream: [
                turbo_stream.replace("saved-message", partial: "products/shared/successful_add"),
                turbo_stream.replace("wishlist-counter", partial: "wish_lists/wish_list_counter")
            ]
        else
           render turbo_stream: turbo_stream.replace("saved-message", partial: "products/shared/unsuccessful_add")
        end
    end

    def destroy
        @wish_list = current_user.wish_lists.find(params[:id])
        @wish_list.destroy
        render turbo_stream: [ turbo_stream.replace("variant_#{@wish_list.variant.id}", 
            partial: "wish_lists/empty"),
            turbo_stream.replace("wishlist-counter", partial: "wish_lists/wish_list_remove")
    ]
        # redirect_to wish_lists_path, notice: "Removed from wish list."
    end

    def update
        @wish_list = WishList.find_by(user_id: current_user.id, variant_id: params[:variant_id])
        quantity = params[:quantity].to_i
        stock = @wish_list.variant.stock

        if quantity > stock  || quantity < 1
            render turbo_stream: turbo_stream.replace("variant_#{@wish_list.variant.id}", 
            partial: "wish_lists/wish_list_quantity",
            locals: { wish_list: @wish_list })
            return
        end

        @wish_list.update!(quantity: params[:quantity])
            render turbo_stream: turbo_stream.replace("variant_#{@wish_list.variant.id}", 
            partial: "wish_lists/wish_list_quantity",
            locals: { wish_list: @wish_list })
    end

    private
    def wish_list_params
        params.expect(wish_list: [:variant_id, :quantity])
    end
end
