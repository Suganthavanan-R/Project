class Bill < ApplicationRecord
  belongs_to :customer
  has_many :line_items
end
