# app/controllers/input_controller.rb
class InputController < ApplicationController
  def index
    # This action is responsible for displaying the input form to the user.
    # Retrieve necessary data for the form, such as product details, from the database.
    @products = Product.all # Replace with your actual product retrieval logic.
    @product_options = @products.map { |product| [product.name, product.id] }
    session[:line_items] ||= []
  end

  def generate_bill
    denominations_params = params[:denominations].permit!
    # Step 1: Retrieve user input from the form
    customer_email = params[:customer_email]
    product_ids = params[:product_ids]
    quantities = params[:quantities]
    cash_paid = params[:cash_paid].to_f

    # Step 2: Calculate the bill based on the input
    # Retrieve product details from the database based on product_ids.
    products = Product.where(id: product_ids)

    # Calculate the purchased price, tax, and total for each selected product based on quantities.
    line_items = calculate_line_items(products, quantities)

    # Calculate total price without tax
    total_price_without_tax = calculate_total_price(line_items)

    # Calculate total tax payable
    total_tax_payable = calculate_total_tax_payable(line_items)

    # Calculate the net price (total_price_without_tax + total_tax_payable)
    net_price = total_price_without_tax.to_f + total_tax_payable.to_f
    # Calculate the rounded down value
    rounded_down_value = net_price.round

    # Calculate the balance payable to the customer
    balance_payable_to_customer = cash_paid - rounded_down_value

    # Step 3: Handling Denominations
    # Process the customer's input for denominations and calculate the total amount of denominations
    @customer_denominations = denominations_params.reject { |_, quantity| quantity.blank? }.to_h
    total_denominations = calculate_total_denominations(@customer_denominations)

    # Calculate the balance amount based on denominations
    balance_based_on_denominations = total_denominations - cash_paid

    # Store the calculated denominations and balance in instance variables
    @total_denominations = total_denominations
    @balance_based_on_denominations = balance_based_on_denominations

    # Step 4: Display the bill
    # Pass the calculated bill details to the bill view for rendering.
    @customer_email = customer_email
    @line_items = session[:line_items]
    @total_price_without_tax = total_price_without_tax
    @total_tax_payable = total_tax_payable
    @net_price = net_price
    @rounded_down_value = rounded_down_value
    @balance_payable_to_customer = balance_payable_to_customer

    # Save or update the line_items in the session
    session[:line_items] = line_items
    line_items.each do |line_item|
      LineItem.create(
        product_id: line_item[:product_id],
        quantity: line_item[:quantity],
        purchased_price: line_item[:purchased_price],
        tax: line_item[:tax],
        tax_pay: line_item[:tax_pay],
        total: line_item[:total]
      )
    end
    @line_items = line_items
    @amount = @balance_payable_to_customer
    @five_hundred = (@amount / 500).floor
    @amount %= 500

    @fifty = (@amount / 50).floor
    @amount %= 50

    @twenty = (@amount / 20).floor
    @amount %= 20

    @ten = (@amount / 10).floor
    @amount %= 10

    @five = (@amount / 5).floor
    @amount %= 5

    @two = (@amount / 2).floor
    @amount %= 2

    @one = @amount.floor
    Bill.create(customer_email: @customer_email, total_price: @total_price_without_tax, total_tax_payable: @total_tax_payable, net_price: @net_price, rounded_down_value: @rounded_down_value, balance_payable_to_customer: @balance_payable_to_customer)
    render 'generate_bill'
  end

  private

  def calculate_line_items(products, quantities)
    line_items = []

    products.each_with_index do |product, index|
      # Retrieve product details
      product_id = product.id
      product_name = product.name
      unit_price = product.price
      tax_percentage = product.tax_percentage
      price = product.price

      # Retrieve quantity for the current product
      quantity = quantities[index].to_i

      # Calculate purchased price for the current product (unit_price * quantity)
      purchased_price = unit_price * quantity

      # Calculate tax for the current product (tax_percentage/100 * purchased_price)
      tax_pay = (tax_percentage.to_f / 100) * purchased_price

      # Calculate tax pay for the current product (tax * quantity)
      # tax_pay = tax * quantity

      # Create a line item hash for the current product
      line_item = {
        product_id: product_id,
        product_name: product_name,
        unit_price: unit_price,
        quantity: quantity,
        purchased_price: purchased_price,
        tax: tax_percentage, # Change to tax_percentage here
        tax_pay: tax_pay,
        total: purchased_price + tax_pay
      }

      # Add the line item to the array
      line_items << line_item
    end

    return line_items
  end

  def calculate_total_price(line_items)
    total_price_without_tax = 0

    line_items.each do |line_item|
      # Retrieve the purchased price for the current line item
      purchased_price = line_item[:purchased_price]

      # Add the purchased price to the total price without tax
      total_price_without_tax += purchased_price
    end

    return total_price_without_tax
  end

  def calculate_total_denominations(customer_denominations)
    total_denominations = 0
    customer_denominations.each do |denomination_value, quantity|
      total_denominations += denomination_value.to_i * quantity.to_i
    end
    total_denominations
  end

  def add_line_item
    product_id = params[:product_id]
    quantity = params[:quantity].to_i

    # Retrieve the product name based on the product_id (assuming you have a Product model)
    product = Product.find(product_id)
    product_name = product.name

    # Create a line item hash with product_id, product_name, and quantity
    line_item = { product_id: product_id, product_name: product_name, quantity: quantity }

    # Store the line item in the session
    session[:line_items] << line_item

    # Redirect back to the input page
    redirect_to input_index_path
  end

  def calculate_total_tax_payable(line_items)
    total_tax_payable = 0

    line_items.each do |line_item|
      # Retrieve the tax pay amount for the current line item
      tax_pay = line_item[:tax_pay]

      # Add the tax pay amount to the total tax payable
      total_tax_payable += tax_pay
    end

    return total_tax_payable
  end

end
