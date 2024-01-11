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

end
