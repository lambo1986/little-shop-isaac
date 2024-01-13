require "rails_helper"

RSpec.describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }

    it "more than 5 active coupons for a merchant is not valid" do
      merchant1 = Merchant.create!(name: "Sweetwater", status: :enabled)
      coupon1 = merchant1.coupons.create!(name: "Buy One Get One 50%", code: "BOGO50", percent_off: 50, dollar_off: 0, active: true)
      coupon2 = merchant1.coupons.create!(name: "15 Dollars Off", code: "15BUCKS", percent_off: 0, dollar_off: 15, active: true)
      coupon3 = merchant1.coupons.create!(name: "15 Percent Off", code: "15PERCENT", percent_off: 15, dollar_off: 0, active: true)
      coupon4 = merchant1.coupons.create!(name: "25 Percent Off", code: "25PERCENT", percent_off: 25, dollar_off: 0, active: true)
      coupon5 = merchant1.coupons.create!(name: "30% Off", code: "GET30%", percent_off: 30, dollar_off: 0, active: true)
      coupon6 = merchant1.coupons.new(name: "50 Percent Off", code: "50PERCENT", percent_off: 50, dollar_off: 0, active: true)
      coupon6.save

      expect(coupon6).not_to be_valid
      expect(coupon6.errors[:base]).to include("Only 5 active coupons can be used at a time.")
    end
  end

  describe "associations" do
    it { should have_many :items }
    it { should have_many(:invoices).through(:items) }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:coupons) }
  end

  describe "associations" do
    it "#enums" do
      merchant = Merchant.create!(name: "Test Merchant", status: "enabled")
      merchant2 = Merchant.create!(name: "Test Merchant2", status: "disabled")
      item = merchant.items.create!(name: "popcan", description: "fun", unit_price: 100)
      customer1 = Customer.create!(first_name: "John", last_name: "Smith")
      customer2 = Customer.create!(first_name: "Jane", last_name: "Sornes")
      customer3 = Customer.create!(first_name: "Jaques", last_name: "Snipes")
      customer4 = Customer.create!(first_name: "Jay", last_name: "Snape")
      customer5 = Customer.create!(first_name: "Tom", last_name: "Bullocks")
      customer6 = Customer.create!(first_name: "Jimmy", last_name: "Dirt")
      invoice1 = customer1.invoices.create!(status: 2)
      invoice2 = customer2.invoices.create!(status: 2)
      invoice3 = customer3.invoices.create!(status: 2)
      invoice4 = customer4.invoices.create!(status: 2)
      invoice5 = customer5.invoices.create!(status: 2)
      invoice6 = customer6.invoices.create!(status: 2)
      invoice_item1 = invoice1.invoice_items.create!(item_id: item.id, quantity: 1, unit_price: 100, status: 2)
      invoice_item2 = invoice1.invoice_items.create!(item_id: item.id, quantity: 1, unit_price: 156, status: 2)
      invoice_item3 = invoice2.invoice_items.create!(item_id: item.id, quantity: 1, unit_price: 340, status: 2)
      invoice_item4 = invoice2.invoice_items.create!(item_id: item.id, quantity: 1, unit_price: 354, status: 2)
      invoice_item5 = invoice3.invoice_items.create!(item_id: item.id, quantity: 1, unit_price: 4, status: 2)
      invoice_item6 = invoice3.invoice_items.create!(item_id: item.id, quantity: 1, unit_price: 1030, status: 2)
      invoice_item7 = invoice4.invoice_items.create!(item_id: item.id, quantity: 1, unit_price: 1070, status: 2)
      invoice_item8 = invoice4.invoice_items.create!(item_id: item.id, quantity: 1, unit_price: 1200, status: 2)
      invoice_item9 = invoice5.invoice_items.create!(item_id: item.id, quantity: 1, unit_price: 600, status: 2)
      invoice_item10 = invoice5.invoice_items.create!(item_id: item.id, quantity: 1, unit_price: 2100, status: 2)
      transaction1 = invoice1.transactions.create!(credit_card_number: 1238567890123476, credit_card_expiration_date: "04/26", result: 0)
      transaction2 = invoice2.transactions.create!(credit_card_number: 1238567590123476, credit_card_expiration_date: "04/26", result: 0)
      transaction3 = invoice3.transactions.create!(credit_card_number: 1238634646123476, credit_card_expiration_date: "04/26", result: 0)
      transaction4 = invoice4.transactions.create!(credit_card_number: 1238567876567476, credit_card_expiration_date: "04/26", result: 0)
      transaction5 = invoice5.transactions.create!(credit_card_number: 1238553460128476, credit_card_expiration_date: "04/26", result: 0)

      expect(merchant.enabled?).to be true
      expect(merchant2.disabled?).to be true
    end
  end

  describe "instance methods" do
    it "has a #transactions method to find all transactions for a merchant" do
      merchant = Merchant.create!(name: "Test Merchant")
      item = merchant.items.create!(name: "popcan", description: "fun", unit_price: 100)
      customer1 = Customer.create!(first_name: "John", last_name: "Smith")
      customer2 = Customer.create!(first_name: "John", last_name: "Smith")
      invoice1 = customer1.invoices.create!(status: 2)
      invoice2 = customer2.invoices.create!(status: 2)
      invoice_item1 = invoice1.invoice_items.create!(item_id: item.id, quantity: 1, unit_price: 100, status: 2)
      invoice_item2 = invoice2.invoice_items.create!(item_id: item.id, quantity: 1, unit_price: 100, status: 2)
      transaction1 = invoice1.transactions.create!(credit_card_number: 1238567890123476, credit_card_expiration_date: "04/26", result: 0)
      transaction2 = invoice2.transactions.create!(credit_card_number: 1238567890123476, credit_card_expiration_date: "04/26", result: 0)

      expect(merchant.transactions).to include(transaction1, transaction2)
    end

    it "has a #top_customers method to find 5 customers with the most transactions" do
      merchant = Merchant.create!(name: "Test Merchant")
      item = merchant.items.create!(name: "popcan", description: "fun", unit_price: 100)
      customer1 = Customer.create!(first_name: "John", last_name: "Smith")
      customer2 = Customer.create!(first_name: "Jane", last_name: "Sornes")
      customer3 = Customer.create!(first_name: "Jaques", last_name: "Snipes")
      customer4 = Customer.create!(first_name: "Jay", last_name: "Snape")
      customer5 = Customer.create!(first_name: "Tom", last_name: "Bullocks")
      customer6 = Customer.create!(first_name: "Jimmy", last_name: "Dirt")
      invoice1 = customer1.invoices.create!(status: 2)
      invoice2 = customer2.invoices.create!(status: 2)
      invoice3 = customer3.invoices.create!(status: 2)
      invoice4 = customer4.invoices.create!(status: 2)
      invoice5 = customer5.invoices.create!(status: 2)
      invoice6 = customer6.invoices.create!(status: 2)
      invoice_item1 = invoice1.invoice_items.create!(item_id: item.id, quantity: 1, unit_price: 100, status: 2)
      invoice_item2 = invoice1.invoice_items.create!(item_id: item.id, quantity: 1, unit_price: 156, status: 2)
      invoice_item3 = invoice2.invoice_items.create!(item_id: item.id, quantity: 1, unit_price: 340, status: 2)
      invoice_item4 = invoice2.invoice_items.create!(item_id: item.id, quantity: 1, unit_price: 354, status: 2)
      invoice_item5 = invoice3.invoice_items.create!(item_id: item.id, quantity: 1, unit_price: 4, status: 2)
      invoice_item6 = invoice3.invoice_items.create!(item_id: item.id, quantity: 1, unit_price: 1030, status: 2)
      invoice_item7 = invoice4.invoice_items.create!(item_id: item.id, quantity: 1, unit_price: 1070, status: 2)
      invoice_item8 = invoice4.invoice_items.create!(item_id: item.id, quantity: 1, unit_price: 1200, status: 2)
      invoice_item9 = invoice5.invoice_items.create!(item_id: item.id, quantity: 1, unit_price: 600, status: 2)
      invoice_item10 = invoice5.invoice_items.create!(item_id: item.id, quantity: 1, unit_price: 2100, status: 2)
      transaction1 = invoice1.transactions.create!(credit_card_number: 1238567890123476, credit_card_expiration_date: "04/26", result: 0)
      transaction2 = invoice2.transactions.create!(credit_card_number: 1238567590123476, credit_card_expiration_date: "04/26", result: 0)
      transaction3 = invoice3.transactions.create!(credit_card_number: 1238634646123476, credit_card_expiration_date: "04/26", result: 0)
      transaction4 = invoice4.transactions.create!(credit_card_number: 1238567876567476, credit_card_expiration_date: "04/26", result: 0)
      transaction5 = invoice5.transactions.create!(credit_card_number: 1238553460128476, credit_card_expiration_date: "04/26", result: 0)

      expect(merchant.top_customers).to include(customer1, customer2, customer3, customer4, customer5)
      expect(merchant.top_customers).to_not include(customer6)
    end

    it "has a #not_yet_shipped_ascending method" do
      merchant = Merchant.create!(name: "Walmart")
      item1 = merchant.items.create!(name: "popcan", description: "fun", unit_price: 100)
      item2 = merchant.items.create!(name: "popper", description: "fun", unit_price: 156)
      item3 = merchant.items.create!(name: "zipper", description: "pants", unit_price: 340)
      item4 = merchant.items.create!(name: "zoozah", description: "doot", unit_price: 354)
      item5 = merchant.items.create!(name: "oiko", description: "zeelk", unit_price: 4)
      item6 = merchant.items.create!(name: "onion pillow", description: "kids", unit_price: 1030)
      item7 = merchant.items.create!(name: "stash", description: "costume", unit_price: 1070)
      item8 = merchant.items.create!(name: "bbq pork powder", description: "toothpaste", unit_price: 1200)
      item9 = merchant.items.create!(name: "arrows", description: "survival", unit_price: 600)
      item10 = merchant.items.create!(name: "cream of pickles", description: "body care", unit_price: 2100)
      item11 = merchant.items.create!(name: "elephant", description: "livestock", unit_price: 2345100)
      item12 = merchant.items.create!(name: "car seat cooler", description: "experimental", unit_price: 23100)
      item13 = merchant.items.create!(name: "sorry notes", description: "dating", unit_price: 10430)
      item14 = merchant.items.create!(name: "crimson tie", description: "costume", unit_price: 10)
      item15 = merchant.items.create!(name: "syrup", description: "self help", unit_price: 13040)
      customer1 = Customer.create!(first_name: "John", last_name: "Smith")
      customer2 = Customer.create!(first_name: "Jane", last_name: "Sornes")
      customer3 = Customer.create!(first_name: "Jaques", last_name: "Snipes")
      customer4 = Customer.create!(first_name: "Jay", last_name: "Snape")
      customer5 = Customer.create!(first_name: "Tom", last_name: "Bullocks")
      customer6 = Customer.create!(first_name: "Jimmy", last_name: "Dirt")
      customer7 = Customer.create!(first_name: "Helva", last_name: "Harrock")
      invoice1 = customer1.invoices.create!(status: 2)
      invoice2 = customer2.invoices.create!(status: 2)
      invoice3 = customer3.invoices.create!(status: 2)
      invoice4 = customer4.invoices.create!(status: 2)
      invoice5 = customer5.invoices.create!(status: 2)
      invoice6 = customer6.invoices.create!(status: 2)
      invoice7 = customer7.invoices.create!(status: 2)
      invoice_item1 = invoice1.invoice_items.create!(item_id: item1.id, quantity: 1, unit_price: 100, status: 1)
      invoice_item2 = invoice1.invoice_items.create!(item_id: item2.id, quantity: 1, unit_price: 156, status: 0)
      invoice_item3 = invoice1.invoice_items.create!(item_id: item3.id, quantity: 1, unit_price: 340, status: 1)
      invoice_item4 = invoice1.invoice_items.create!(item_id: item4.id, quantity: 1, unit_price: 354, status: 0)
      invoice_item5 = invoice1.invoice_items.create!(item_id: item5.id, quantity: 1, unit_price: 4, status: 1)
      invoice_item6 = invoice2.invoice_items.create!(item_id: item6.id, quantity: 1, unit_price: 1030, status: 2)
      invoice_item7 = invoice2.invoice_items.create!(item_id: item7.id, quantity: 1, unit_price: 1070, status: 2)
      invoice_item8 = invoice2.invoice_items.create!(item_id: item8.id, quantity: 1, unit_price: 1200, status: 1)
      invoice_item9 = invoice2.invoice_items.create!(item_id: item9.id, quantity: 1, unit_price: 600, status: 2)
      invoice_item10 = invoice3.invoice_items.create!(item_id: item10.id, quantity: 1, unit_price: 2100, status: 0)
      invoice_item11 = invoice3.invoice_items.create!(item_id: item11.id, quantity: 1, unit_price: 2345100, status: 2)
      invoice_item12 = invoice3.invoice_items.create!(item_id: item12.id, quantity: 1, unit_price: 23100, status: 2)
      invoice_item13 = invoice4.invoice_items.create!(item_id: item13.id, quantity: 1, unit_price: 10430, status: 2)
      invoice_item14 = invoice4.invoice_items.create!(item_id: item14.id, quantity: 1, unit_price: 10, status: 2)
      invoice_item15 = invoice5.invoice_items.create!(item_id: item15.id, quantity: 1, unit_price: 13040, status: 2)
      transaction1 = invoice1.transactions.create!(credit_card_number: 1238567890123476, credit_card_expiration_date: "04/26", result: 0)
      transaction2 = invoice2.transactions.create!(credit_card_number: 1238567590123476, credit_card_expiration_date: "04/26", result: 0)
      transaction3 = invoice3.transactions.create!(credit_card_number: 1238634646123476, credit_card_expiration_date: "04/26", result: 0)
      transaction4 = invoice4.transactions.create!(credit_card_number: 1238567876567476, credit_card_expiration_date: "04/26", result: 0)
      transaction5 = invoice5.transactions.create!(credit_card_number: 1238553460128476, credit_card_expiration_date: "04/26", result: 0)

      expected = merchant.not_yet_shipped_ascending.map { |x| x.invoice_id }

      expect(expected).to include(invoice_item1.invoice_id, invoice_item8.invoice_id, invoice_item10.invoice_id)

      expected = merchant.not_yet_shipped_ascending.map { |x| x.name }

      expect(expected).to include(item1.name, item2.name, item3.name)
    end
  end

  it "has a #top_earning_items method" do #presentation
    merchant_1 = Merchant.create!(name: "Walmart")
    item1 = merchant_1.items.create!(name: "popcan", description: "fun", unit_price: 100)
    item2 = merchant_1.items.create!(name: "popper", description: "fun", unit_price: 156)
    item3 = merchant_1.items.create!(name: "zipper", description: "pants", unit_price: 340)
    item4 = merchant_1.items.create!(name: "zoozah", description: "doot", unit_price: 354)
    item5 = merchant_1.items.create!(name: "oiko", description: "zeelk", unit_price: 4)
    item6 = merchant_1.items.create!(name: "onion pillow", description: "kids", unit_price: 1030)
    item7 = merchant_1.items.create!(name: "stash", description: "costume", unit_price: 1070)
    item8 = merchant_1.items.create!(name: "bbq pork powder", description: "toothpaste", unit_price: 1200)
    item9 = merchant_1.items.create!(name: "arrows", description: "survival", unit_price: 600)
    item10 = merchant_1.items.create!(name: "cream of pickles", description: "body care", unit_price: 2100)
    item11 = merchant_1.items.create!(name: "elephant", description: "livestock", unit_price: 2345100)
    item12 = merchant_1.items.create!(name: "car seat cooler", description: "experimental", unit_price: 23100)
    item13 = merchant_1.items.create!(name: "sorry notes", description: "dating", unit_price: 10430)
    item14 = merchant_1.items.create!(name: "crimson tie", description: "costume", unit_price: 10)
    item15 = merchant_1.items.create!(name: "syrup", description: "self help", unit_price: 13040)
    customer1 = Customer.create!(first_name: "John", last_name: "Smith")
    customer2 = Customer.create!(first_name: "Jane", last_name: "Sornes")
    customer3 = Customer.create!(first_name: "Jaques", last_name: "Snipes")
    customer4 = Customer.create!(first_name: "Jay", last_name: "Snape")
    customer5 = Customer.create!(first_name: "Tom", last_name: "Bullocks")
    customer6 = Customer.create!(first_name: "Jimmy", last_name: "Dirt")
    customer7 = Customer.create!(first_name: "Helva", last_name: "Harrock")
    invoice1 = customer1.invoices.create!(status:2)
    invoice2 = customer2.invoices.create!(status: 2)
    invoice3 = customer3.invoices.create!(status: 2)
    invoice4 = customer4.invoices.create!(status: 2)
    invoice5 = customer5.invoices.create!(status: 2)
    invoice6 = customer6.invoices.create!(status: 2)
    invoice7 = customer7.invoices.create!(status: 2)#13567
    invoice_item1 = invoice1.invoice_items.create!(item_id: item1.id, quantity: 6, unit_price: 100, status: 2)
    invoice_item2 = invoice1.invoice_items.create!(item_id: item2.id, quantity: 2, unit_price: 156, status: 2)
    invoice_item3 = invoice1.invoice_items.create!(item_id: item3.id, quantity: 11, unit_price: 340, status: 2)
    invoice_item4 = invoice2.invoice_items.create!(item_id: item4.id, quantity: 18, unit_price: 354, status: 2)
    invoice_item5 = invoice2.invoice_items.create!(item_id: item5.id, quantity: 4, unit_price: 4, status: 2)
    invoice_item6 = invoice3.invoice_items.create!(item_id: item6.id, quantity: 1, unit_price: 1030, status: 2)
    invoice_item7 = invoice3.invoice_items.create!(item_id: item7.id, quantity: 4, unit_price: 1070, status: 2)
    invoice_item8 = invoice4.invoice_items.create!(item_id: item8.id, quantity: 3, unit_price: 1200, status: 2)
    invoice_item9 = invoice4.invoice_items.create!(item_id: item9.id, quantity: 5, unit_price: 600, status: 2)
    invoice_item10 = invoice4.invoice_items.create!(item_id: item10.id, quantity: 1, unit_price: 2100, status: 2)
    invoice_item11 = invoice5.invoice_items.create!(item_id: item11.id, quantity: 5, unit_price: 2345100, status: 2)
    invoice_item12 = invoice5.invoice_items.create!(item_id: item12.id, quantity: 7, unit_price: 23100, status: 2)
    invoice_item13 = invoice6.invoice_items.create!(item_id: item13.id, quantity: 3, unit_price: 10430, status: 2)
    invoice_item14 = invoice7.invoice_items.create!(item_id: item14.id, quantity: 7, unit_price: 10, status: 2)
    invoice_item15 = invoice7.invoice_items.create!(item_id: item15.id, quantity: 2, unit_price: 13040, status: 2)
    transaction1 = invoice1.transactions.create!(credit_card_number: 1238567890123476, credit_card_expiration_date: "04/30", result: 0)
    transaction2 = invoice2.transactions.create!(credit_card_number: 1238567590123476, credit_card_expiration_date: "04/28", result: 1)
    transaction3 = invoice3.transactions.create!(credit_card_number: 1238634646123476, credit_card_expiration_date: "04/15", result: 0)
    transaction4 = invoice4.transactions.create!(credit_card_number: 1238567876567476, credit_card_expiration_date: "04/12", result: 1)
    transaction5 = invoice5.transactions.create!(credit_card_number: 1238553460128476, credit_card_expiration_date: "04/25", result: 0)
    transaction6 = invoice6.transactions.create!(credit_card_number: 1238553460128476, credit_card_expiration_date: "04/24", result: 0)
    transaction7 = invoice7.transactions.create!(credit_card_number: 1238553460128476, credit_card_expiration_date: "04/23", result: 0)

    expect(merchant_1.top_earning_items.count).to eq(5)
    expect(merchant_1.top_earning_items.first.name).to eq("elephant")
    expect(merchant_1.top_earning_items.last.name).to eq("stash")
    expect(merchant_1.top_earning_items.first.total_revenue).to eq(11725500)
  end

  it "has a #merchant_invoices method" do
    merchant_1 = Merchant.create!(name: "Walmart")
    merchant_2 = Merchant.create!(name: "Temu")
    item1 = merchant_1.items.create!(name: "popcan", description: "fun", unit_price: 100)
    item2 = merchant_1.items.create!(name: "popper", description: "fun", unit_price: 156)
    item3 = merchant_1.items.create!(name: "zipper", description: "pants", unit_price: 340)
    item4 = merchant_2.items.create!(name: "zoozah", description: "doot", unit_price: 354)
    item5 = merchant_2.items.create!(name: "oiko", description: "zeelk", unit_price: 4)
    item6 = merchant_2.items.create!(name: "onion pillow", description: "kids", unit_price: 1030)
    item7 = merchant_2.items.create!(name: "stash", description: "costume", unit_price: 1070)
    customer1 = Customer.create!(first_name: "John", last_name: "Smith")
    customer2 = Customer.create!(first_name: "Jane", last_name: "Sornes")
    customer3 = Customer.create!(first_name: "Jaques", last_name: "Snipes")
    invoice1 = customer1.invoices.create!(status: 2)
    invoice2 = customer2.invoices.create!(status: 2)
    invoice3 = customer3.invoices.create!(status: 2)
    invoice_item1 = invoice1.invoice_items.create!(item_id: item1.id, quantity: 1, unit_price: 100, status: 1)
    invoice_item2 = invoice1.invoice_items.create!(item_id: item2.id, quantity: 2, unit_price: 156, status: 0)
    invoice_item3 = invoice2.invoice_items.create!(item_id: item3.id, quantity: 1, unit_price: 340, status: 1)
    invoice_item4 = invoice2.invoice_items.create!(item_id: item4.id, quantity: 4, unit_price: 354, status: 0)
    invoice_item5 = invoice3.invoice_items.create!(item_id: item5.id, quantity: 23, unit_price: 4, status: 1)
    invoice_item6 = invoice3.invoice_items.create!(item_id: item6.id, quantity: 6, unit_price: 1030, status: 2)
    transaction1 = invoice1.transactions.create!(credit_card_number: 1238567890123476, credit_card_expiration_date: "04/26", result: 0)
    transaction2 = invoice2.transactions.create!(credit_card_number: 1238567590123476, credit_card_expiration_date: "04/26", result: 0)
    transaction3 = invoice3.transactions.create!(credit_card_number: 1238634646123476, credit_card_expiration_date: "04/26", result: 0)

    expect(merchant_1.merchant_invoices.count).to eq(2)
    expect(merchant_1.merchant_invoices).to include(invoice1, invoice2)
    expect(merchant_2.merchant_invoices.count).to eq(2)
    expect(merchant_2.merchant_invoices).to include(invoice2, invoice3)
  end

  it "has a #total_invoice_revenue method" do
    merchant_1 = Merchant.create!(name: "Walmart")
    merchant_2 = Merchant.create!(name: "Temu")
    item1 = merchant_1.items.create!(name: "popcan", description: "fun", unit_price: 100)
    item2 = merchant_1.items.create!(name: "popper", description: "fun", unit_price: 156)
    item3 = merchant_2.items.create!(name: "copper", description: "money", unit_price: 243)
    customer1 = Customer.create!(first_name: "John", last_name: "Smith")
    customer2 = Customer.create!(first_name: "Jane", last_name: "Sornes")
    invoice1 = customer1.invoices.create!(status: 2)
    invoice2 = customer2.invoices.create!(status: 2)
    invoice_item1 = invoice1.invoice_items.create!(item_id: item1.id, quantity: 1, unit_price: 99, status: 0)
    invoice_item2 = invoice1.invoice_items.create!(item_id: item2.id, quantity: 2, unit_price: 133, status: 1)
    invoice_item3 = invoice1.invoice_items.create!(item_id: item3.id, quantity: 1, unit_price: 210, status: 2)
    invoice_item4 = invoice2.invoice_items.create!(item_id: item1.id, quantity: 1, unit_price: 340, status: 2)
    transaction1 = invoice1.transactions.create!(credit_card_number: 1238567890123476, credit_card_expiration_date: "04/26", result: 0)
    transaction2 = invoice2.transactions.create!(credit_card_number: 1238567590123476, credit_card_expiration_date: "04/26", result: 0)

    expect(merchant_1.total_invoice_revenue(invoice1)).to eq(365)
  end

  it "has a #revenue_after_coupons method" do# US-7
    merchant1 = Merchant.create!(name: "Walmart")
    merchant2 = Merchant.create!(name: "Temu")
    coupon1 = merchant1.coupons.create!(name: "Buy One Get One 50%", code: "BOGO50", percent_off: 50, dollar_off: 0, active: true)
    coupon2 = merchant2.coupons.create!(name: "10 Bucks Off", code: "10OFF", percent_off: 0, dollar_off: 10, active: true)
    coupon3 = merchant2.coupons.create!(name: "100 Bucks Off", code: "100OFF", percent_off: 0, dollar_off: 100, active: true)
    item1 = merchant1.items.create!(name: "popcan", description: "fun", unit_price: 100)
    item2 = merchant1.items.create!(name: "popper", description: "fun", unit_price: 156)
    item3 = merchant2.items.create!(name: "copper", description: "money", unit_price: 243)
    item4 = merchant2.items.create!(name: "chalk", description: "kids", unit_price: 333)
    item5 = merchant1.items.create!(name: "clock", description: "home", unit_price: 5000)#make sure it is 0 if negative after coupon
    customer1 = Customer.create!(first_name: "John", last_name: "Smith")
    invoice1 = coupon1.invoices.create!(status: 2, customer: customer1)#total $4.12 for merchant1
    invoice2 = coupon2.invoices.create!(status: 2, customer: customer1)
    invoice3 = coupon3.invoices.create!(status: 2, customer: customer1)
    invoice_item1 = invoice1.invoice_items.create!(item_id: item1.id, quantity: 1, unit_price: 100, status: 0)#merchant1
    invoice_item2 = invoice1.invoice_items.create!(item_id: item2.id, quantity: 2, unit_price: 156, status: 1)#merchant1
    invoice_item3 = invoice1.invoice_items.create!(item_id: item3.id, quantity: 1, unit_price: 243, status: 2)#merchant2 (A coupon code from a Merchant only applies to Items sold by that Merchant)
    invoice_item4 = invoice2.invoice_items.create!(item_id: item4.id, quantity: 6, unit_price: 333, status: 2)
    invoice_item5 = invoice3.invoice_items.create!(item_id: item5.id, quantity: 1, unit_price: 5000, status: 2)
    transaction1 = invoice1.transactions.create!(credit_card_number: 1238567890123476, credit_card_expiration_date: "04/26", result: 0)
    transaction2 = invoice2.transactions.create!(credit_card_number: 9878567544323879, credit_card_expiration_date: "04/30", result: 0)
    transaction3 = invoice2.transactions.create!(credit_card_number: 7678564565323424, credit_card_expiration_date: "03/23", result: 0)

    expect(merchant1.revenue_after_coupons(invoice1)).to eq(206)
    expect(merchant1.revenue_after_coupons(invoice2)).to eq(0)
    expect(merchant1.revenue_after_coupons(invoice3)).to eq(0)
    expect(merchant2.revenue_after_coupons(invoice1)).to eq(121.5)
    expect(merchant2.revenue_after_coupons(invoice2)).to eq(998)
    expect(merchant2.revenue_after_coupons(invoice3)).to eq(0)
  end

  it "has a #merchant_coupons method" do# US-7 Why did I make this method?
    merchant1 = Merchant.create!(name: "Walmart")
    coupon1 = merchant1.coupons.create!(name: "Buy One Get One 50%", code: "BOGO50", percent_off: 50, dollar_off: 0, active: true)
    customer1 = Customer.create!(first_name: "John", last_name: "Smith")
    invoice1 = coupon1.invoices.create!(status: 2, customer: customer1)

    expect(merchant1.merchant_coupons).to include(coupon1)
  end
end
