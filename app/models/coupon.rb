class Coupon < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
  validates :percent_off, presence: true
  validates :dollar_off, presence: true
  validates :active, presence: true
  validate :validate_active_coupons_limit, on: :create

  belongs_to :merchant
  has_many :invoices

  private

  def validate_active_coupons_limit
    if merchant && merchant.coupons.where(active: true).count >= 5
      errors.add(:base, "Only 5 active coupons can be used at a time.")
    end
  end
end
