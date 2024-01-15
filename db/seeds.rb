# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
if Rails.env.development? || Rails.env.test?

    InvoiceItem.destroy_all
    Transaction.destroy_all
    Invoice.destroy_all
    Coupon.destroy_all
    Item.destroy_all
    Merchant.destroy_all
    Customer.destroy_all
end

  merchant1 = Merchant.create!(name: "Walmart")
  merchant2 = Merchant.create!(name: "Temu")
  coupon1 = merchant1.coupons.create!(name: "Buy One Get One 50%", code: "BOGO50", percent_off: 50, dollar_off: 0, active: true)
  coupon2 = merchant2.coupons.create!(name: "10 Bucks Off", code: "10OFF", percent_off: 0, dollar_off: 10, active: true)
  coupon3 = merchant2.coupons.create!(name: "100 Bucks Off", code: "100OFF", percent_off: 0, dollar_off: 100, active: true)
  coupon4 = merchant1.coupons.create!(name: "Nothing Off", code: "NOTHING", percent_off: 0, dollar_off: 0, active: true)
  coupon5 = merchant1.coupons.create!(name: "20 % Off", code: "TAKE20", percent_off: 20, dollar_off: 0, active: true)
  item1 = merchant1.items.create!(name: "popcan", description: "fun", unit_price: 100)
  item2 = merchant1.items.create!(name: "popper", description: "fun", unit_price: 156)
  item3 = merchant2.items.create!(name: "copper", description: "money", unit_price: 243)
  item4 = merchant2.items.create!(name: "chalk", description: "kids", unit_price: 333)
  item5 = merchant1.items.create!(name: "clock", description: "home", unit_price: 5000)
  item6 = merchant1.items.create!(name: "ring", description: "jewelery", unit_price: 200000)
  item7 = merchant1.items.create!(name: "kangol hat", description: "nostalgia", unit_price: 7500)
  item8 = merchant2.items.create!(name: "tarp", description: "garage", unit_price: 3400)
  customer1 = Customer.create!(first_name: "John", last_name: "Smith")
  customer2 = Customer.create!(first_name: "Jack", last_name: "Sams")
  customer3 = Customer.create!(first_name: "Bertha", last_name: "Bartholomew")
  invoice1 = coupon1.invoices.create!(status: 2, customer: customer1)
  invoice2 = coupon2.invoices.create!(status: 0, customer: customer1)
  invoice3 = coupon3.invoices.create!(status: 1, customer: customer1)
  invoice4 = coupon4.invoices.create!(status: 2, customer: customer2)
  invoice5 = coupon5.invoices.create!(status: 2, customer: customer3)
  invoice_item1 = invoice1.invoice_items.create!(item_id: item1.id, quantity: 1, unit_price: 100, status: 0)
  invoice_item2 = invoice1.invoice_items.create!(item_id: item2.id, quantity: 2, unit_price: 156, status: 1)
  invoice_item3 = invoice1.invoice_items.create!(item_id: item3.id, quantity: 1, unit_price: 243, status: 2)
  invoice_item4 = invoice2.invoice_items.create!(item_id: item4.id, quantity: 6, unit_price: 333, status: 1)
  invoice_item5 = invoice3.invoice_items.create!(item_id: item5.id, quantity: 1, unit_price: 5000, status: 2)
  invoice_item6 = invoice4.invoice_items.create!(item_id: item5.id, quantity: 1, unit_price: 5000, status: 2)
  invoice_item7 = invoice4.invoice_items.create!(item_id: item6.id, quantity: 7, unit_price: 200000, status: 0)
  invoice_item8 = invoice4.invoice_items.create!(item_id: item7.id, quantity: 1, unit_price: 7500, status: 2)
  invoice_item9 = invoice4.invoice_items.create!(item_id: item8.id, quantity: 13, unit_price: 3400, status: 2)
  transaction1 = invoice1.transactions.create!(credit_card_number: 1238567890123476, credit_card_expiration_date: "04/26", result: 0)
  transaction2 = invoice2.transactions.create!(credit_card_number: 1238567590123476, credit_card_expiration_date: "04/26", result: 1)
  transaction3 = invoice3.transactions.create!(credit_card_number: 1238634646123476, credit_card_expiration_date: "04/26", result: 0)
  transaction4 = invoice4.transactions.create!(credit_card_number: 1238634646123476, credit_card_expiration_date: "04/26", result: 0)
  transaction5 = invoice5.transactions.create!(credit_card_number: 1238634646123476, credit_card_expiration_date: "04/26", result: 0)
