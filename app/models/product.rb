class Product < ApplicationRecord
  before_save :calculate_tax_pay

  def calculate_tax_pay
    self.tax_pay = (tax_percentage / 100) * price
  end
end
