class Invoice < ApplicationRecord
  validates :status, presence: true

  belongs_to :customer
  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  belongs_to :coupon, optional: true

  enum status: { in_progress: 0, cancelled: 1, completed: 2 }

  def self.best_day
    self.joins(:invoice_items)
      .select("SUM(invoice_items.unit_price * invoice_items.quantity) AS revenue, invoices.created_at")
      .group(:id)
      .order("revenue DESC")
      .first
  end

  def total_revenue
    self.invoice_items.joins(:item)
      .sum("invoice_items.quantity * invoice_items.unit_price")
  end

  def invoice_revenue_after_coupons#US-8 adapted from merchant method
    @coupon = Coupon.find_by(id: self.coupon_id)
    if @coupon#check for nil
        if @coupon.dollar_off == 0
          self.total_revenue * (@coupon.percent_off.to_f / 100)
      elsif @coupon.percent_off == 0
          total = self.total_revenue - (@coupon.dollar_off * 100)
          total = 0 if total < 0#make sure it doesn't go negative
          total
      end
    end
  end
end
