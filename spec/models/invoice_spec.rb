require "rails_helper"

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of(:status) }
  end

  describe "associations" do
    it { should belong_to :customer }
    it { should have_many :transactions }
    it { should have_many(:invoice_items) }
    it { should have_many(:items).through(:invoice_items) }
    it { should belong_to(:coupon).optional }

    it 'is valid without a coupon' do #had to figure out how to test for this optional association
      customer1 = Customer.create!(first_name: "John", last_name: "Smith")
      invoice1 = customer1.invoices.create!(status: 2)
      expect(invoice1).to be_valid
    end

    it 'can be associated with a coupon' do
      merchant = Merchant.create!(name: "Test Merchant", status: "enabled")
      customer1 = Customer.create!(first_name: "John", last_name: "Smith")
      coupon = merchant.coupons.create!(name: "big sale", code: "BOGO50", percent_off: 50, dollar_off: 0, active: true)
      invoice1 = coupon.invoices.create!(status: 2, customer: customer1)

      expect(invoice1.coupon).to eq(coupon)
    end
  end

  describe "enums" do
    it "has an enum for status" do
      bob = Customer.create!(first_name: "Bob", last_name: "Smith")
      invoice1 = bob.invoices.create!(status: 0)
      invoice2 = bob.invoices.create!(status: 1)
      invoice3 = bob.invoices.create!(status: 2)

      expect(invoice1.in_progress?).to be true
      expect(invoice2.cancelled?).to be true
      expect(invoice3.completed?).to be true
    end
  end

  describe "methods" do
    it ".best_day" do
      merchant_1 = Merchant.create!(name: "Walmart")
      customer1 = Customer.create!(first_name: "John", last_name: "Smith")
      customer2 = Customer.create!(first_name: "Jane", last_name: "Sornes")
      customer3 = Customer.create!(first_name: "Jaques", last_name: "Snipes")
      item1 = merchant_1.items.create!(name: "popcan", description: "fun", unit_price: 10)
      item2 = merchant_1.items.create!(name: "popper", description: "fun", unit_price: 10)
      item3 = merchant_1.items.create!(name: "zipper", description: "pants", unit_price: 10)
      invoice1 = customer1.invoices.create!(created_at: Time.new(2018, 1, 1), status:2)
      invoice2 = customer2.invoices.create!(created_at: Time.new(2018, 2, 2), status: 2)
      invoice3 = customer3.invoices.create!(created_at: Time.new(2018, 3, 3), status: 2)
      invoice_item1 = invoice1.invoice_items.create!(item_id: item1.id, quantity: 1, unit_price: 10, status: 2)
      invoice_item2 = invoice1.invoice_items.create!(item_id: item2.id, quantity: 2, unit_price: 3, status: 2)
      invoice_item3 = invoice1.invoice_items.create!(item_id: item3.id, quantity: 1, unit_price: 10, status: 2)
      invoice_item4 = invoice2.invoice_items.create!(item_id: item1.id, quantity: 2, unit_price: 10, status: 2)
      invoice_item5 = invoice2.invoice_items.create!(item_id: item2.id, quantity: 1, unit_price: 3, status: 2)
      invoice_item6 = invoice2.invoice_items.create!(item_id: item3.id, quantity: 2, unit_price: 10, status: 2)


      expect(Invoice.best_day.created_at.strftime("%m/%d/%y")).to eq("02/02/18")
    end
  end
end
