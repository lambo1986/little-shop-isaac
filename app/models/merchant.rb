class Merchant < ApplicationRecord
  validates :name, presence: true
  
  has_many :items, dependent: :destroy
  has_many :invoices, through: :items
  has_many :invoice_items, through: :items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices
end
