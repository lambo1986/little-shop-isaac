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
  end
end
