class WishListsController < ApplicationController
    def index
        @wish_lists = current_user.wish_lists.includes(variant: :product)
    end

    def create
  
        @wish_list = WishList.find_by(user_id: current_user.id, variant_id: params[:wish_list][:variant_id])
        unless @wish_list.nil?
            quantity = @wish_list.quantity + params[:wish_list][:quantity].to_i
            variant = Variant.find(params[:wish_list][:variant_id])
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
        redirect_to wish_lists_path, notice: "Removed from wish list."
    end

    def update
    end

    private
    def wish_list_params
        params.expect(wish_list: [:variant_id, :quantity])
    end
end
