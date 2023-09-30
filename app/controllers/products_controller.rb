# app/controllers/products_controller.rb
class ProductsController < ApplicationController
  def index
    @products = Product.all # Replace with your actual product retrieval logic
    # render json: @products
  end
  def new
    @product = Product.new
  end

  # app/controllers/products_controller.rb
  def edit
    @product = Product.find(params[:id])
  end
  def products_json
    @products = Product.all # Adjust this to fetch your product data
    render json: @products
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:notice] = 'Product was successfully created.'
       redirect_to products_path, notice: 'Product was successfully created.'
    else
      render :new
    end
  end

  private
  def product_params
    params.require(:product).permit(:name, :price,:tax_percentage)
    end
end
