require "rails_helper"

RSpec.describe Coupon, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:code), unique: true }
    it { should validate_presence_of(:percent_off) }
    it { should validate_presence_of(:dollar_off) }
    it { should validate_presence_of(:active) }

    it "does not validate duplicate coupon codes" do
      merchant1 = Merchant.create!(name: "Sweetwater", status: :enabled)
      coupon1 = merchant1.coupons.create!(name: "Buy One Get One 50%", code: "BOGO50", percent_off: 50, dollar_off: 0, active: true)
      coupon2 = merchant1.coupons.new(name: "Buy One Get Another 50%", code: "BOGO50", percent_off: 50, dollar_off: 0, active: true)

      expect(coupon2.valid?).to be false
      expect(coupon2.errors[:code]).to include("has already been taken")
    end
  end

  describe "associations" do
    it { should belong_to(:merchant) }
    it { should have_many(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe "instance methods" do
    it "has a #times_used method" do
      merchant1 = Merchant.create!(name: "Sweetwater", status: :enabled)
      bob = Customer.create!(first_name: "Bob", last_name: "Smith")
      jerry = Customer.create!(first_name: "Jerry", last_name: "Jones")
      tina = Customer.create!(first_name: "Tina", last_name: "Turner")
      coupon1 = merchant1.coupons.create!(name: "Buy One Get One 50%", code: "BOGO50", percent_off: 50, dollar_off: 0, active: true)
      invoice1 = coupon1.invoices.create!(status: 2, customer: bob)
      invoice2 = coupon1.invoices.create!(status: 2, customer: jerry)
      invoice3 = coupon1.invoices.create!(status: 2, customer: tina)
      transaction1 = invoice1.transactions.create!(credit_card_number: "1234567854", credit_card_expiration_date: "12/20", result: 0)
      transaction2 = invoice2.transactions.create!(credit_card_number: "1236785476", credit_card_expiration_date: "12/23", result: 0)
      transaction2 = invoice3.transactions.create!(credit_card_number: "1236785498", credit_card_expiration_date: "12/22", result: 1)#failed

      expect(coupon1.times_used).to eq(2)
    end
  end
end
