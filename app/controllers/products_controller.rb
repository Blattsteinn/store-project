class ProductsController < ApplicationController
    before_action :authenticate_admin!, only: [:new, :create, :edit, :update, :destroy]

    def index
        @products = Product.all
    end

    def show
        @product = Product.find(params[:id])
    end

    def new
        @product = Product.new
        @product.product_images.build
    end

    def create
        @product = Product.new(product_params)
        if @product.save  
            redirect_to @product
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
        @product = Product.find(params[:id])
        @product.product_images.build
    end

    def update
        @product = Product.find(params[:id])
        
        if @product.update(product_params) 
            flash[:successful_edit] = "Product successfully edited."
            redirect_to dashboard_products_path

        else
            flash.now[:fail_edit]= "Product failed to edit"
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @product = Product.find(params[:id])
        @product.destroy
        redirect_to products_path
    end

    private
    def product_params
        params.expect(product: [:title, :visibility, :description, :pricing, :payment_type, :deliverables, 
        :stock, product_images_attributes: [[:image, :priority, :_destroy, :id]]])
    end

end
