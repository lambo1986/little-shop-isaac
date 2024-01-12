class Coupon < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
  validates :percent_off, presence: true
  validates :dollar_off, presence: true
  validates :active, inclusion: { in: [true, false] }# needed this to get update function to work in merchant_coupons_controller.
  validate :validate_active_coupons_limit, on: :create

  belongs_to :merchant
  has_many :invoices
  has_many :transactions, through: :invoices

  def times_used
    transactions.where(result: 0).count
  end

  def invoice_in_progress?
    invoices.where(status: 0).count > 0
  end

  private

  def validate_active_coupons_limit #adds new error if the merchant has 5 active coupons
    if merchant && merchant.coupons.where(active: true).count >= 5 && active
      errors.add(:base, "Only 5 active coupons can be used at a time.")
    end
  end
end
