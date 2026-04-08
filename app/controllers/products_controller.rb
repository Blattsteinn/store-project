class ProductsController < ApplicationController
    # before_action :authenticate_user!
    # before_action :require_admin!
    def index
        @products = Product.all
    end

    def show
        @product = Product.find(params[:id])
    end

    def new
        @product = Product.new
    end

    def create
        @product = Product.new(product_params)
        if @product.save  
            redirect_to @product
        else
            render :new, status: :unprocessable_entity
        end
    end

    private
    def product_params
        params.expect(product: [:title, :visibility, :description, :pricing, :payment_type, :deliverables, :stock  ])
    end

end
