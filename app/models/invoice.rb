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
      invoice_items.joins(:item)
      .sum("invoice_items.quantity * invoice_items.unit_price")
  end

  def invoice_revenue_after_coupons#US-8 adapted from merchant method
    coupon = Coupon.find_by(id: self.coupon_id)
    if coupon#check for nil
      coupon_items = Item.where(merchant_id: coupon.merchant_id)#make sure coupon only applies to items from the same merchant
      non_coupon_items = Item.where.not(merchant_id: coupon.merchant_id)#items from other merchants(no discount)
      invoice_items = InvoiceItem.where(invoice_id: self.id)
      invoice_coupon_items = invoice_items.where(item_id: coupon_items.pluck(:id))#matching coupon items to invoice items
      invoice_non_coupon_items = invoice_items.where(item_id: non_coupon_items.pluck(:id))#matching non coupon items to invoice items
      invoice_coupon_items_total_price = invoice_coupon_items.map { |item| item.unit_price * item.quantity }.sum
      invoice_non_coupon_items_total_price = invoice_non_coupon_items.map { |item| item.unit_price * item.quantity }.sum
      if coupon.percent_off > 0
        (invoice_coupon_items_total_price * (coupon.percent_off.to_f / 100)) + invoice_non_coupon_items_total_price
      elsif coupon.dollar_off > 0
        total = total_revenue - (coupon.dollar_off.to_f * 100)#make sure dollar_off applies to all invoice_items
        total = 0 if total < 0#make sure it doesn't go negative
        total
      elsif coupon.percent_off == 0 && coupon.dollar_off == 0
        total_revenue
      end
    else
      total_revenue#if there is no coupon
    end
  end
end
