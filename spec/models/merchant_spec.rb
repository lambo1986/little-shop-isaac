require "rails_helper"

RSpec.describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  describe "associations" do
    it { should have_many :items }
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
end