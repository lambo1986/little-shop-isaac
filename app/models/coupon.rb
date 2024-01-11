class Coupon < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
  validates :percent_off, presence: true
  validates :dollar_off, presence: true
  validates :active, presence: true

  belongs_to :merchant
  has_many :invoices
end
