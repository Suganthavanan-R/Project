class Customer < ApplicationRecord
  # Add validations as needed
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  #Associations
  has_many :bills
end
