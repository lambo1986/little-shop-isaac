# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
Customer.destroy_all
Merchant.destroy_all
Invoice.destroy_all
Item.destroy_all
Transaction.destroy_all
InvoiceItem.destroy_all

merchant1 = Merchant.create!(name: "Walmart")
merchant2 = Merchant.create!(name: "Temu")
coupon1 = merchant1.coupons.create!(name: "Buy One Get One 50%", code: "BOGO50", percent_off: 50, dollar_off: 0, active: true)
coupon2 = merchant2.coupons.create!(name: "10 Bucks Off", code: "10OFF", percent_off: 0, dollar_off: 10, active: true)
coupon3 = merchant2.coupons.create!(name: "100 Bucks Off", code: "100OFF", percent_off: 0, dollar_off: 100, active: true)
coupon4 = merchant1.coupons.create!(name: "Nothing Off", code: "NOTHING", percent_off: 0, dollar_off: 0, active: true)
item1 = merchant1.items.create!(name: "popcan", description: "fun", unit_price: 100)
item2 = merchant1.items.create!(name: "popper", description: "fun", unit_price: 156)
item3 = merchant2.items.create!(name: "copper", description: "money", unit_price: 243)
item4 = merchant2.items.create!(name: "chalk", description: "kids", unit_price: 333)
item5 = merchant1.items.create!(name: "clock", description: "home", unit_price: 5000)
customer1 = Customer.create!(first_name: "John", last_name: "Smith")
customer2 = Customer.create!(first_name: "Jack", last_name: "Sams")
invoice1 = coupon1.invoices.create!(status: 2, customer: customer1)
invoice2 = coupon2.invoices.create!(status: 2, customer: customer1)
invoice3 = coupon3.invoices.create!(status: 2, customer: customer1)
invoice4 = coupon4.invoices.create!(status: 2, customer: customer2)
invoice_item1 = invoice1.invoice_items.create!(item_id: item1.id, quantity: 1, unit_price: 100, status: 0)
invoice_item2 = invoice1.invoice_items.create!(item_id: item2.id, quantity: 2, unit_price: 156, status: 1)
invoice_item3 = invoice1.invoice_items.create!(item_id: item3.id, quantity: 1, unit_price: 243, status: 2)
invoice_item4 = invoice2.invoice_items.create!(item_id: item4.id, quantity: 6, unit_price: 333, status: 2)
invoice_item5 = invoice3.invoice_items.create!(item_id: item5.id, quantity: 1, unit_price: 5000, status: 2)
invoice_item6 = invoice4.invoice_items.create!(item_id: item5.id, quantity: 1, unit_price: 5000, status: 2)
transaction1 = invoice1.transactions.create!(credit_card_number: 1238567890123476, credit_card_expiration_date: "04/26", result: 0)
transaction2 = invoice2.transactions.create!(credit_card_number: 1238567590123476, credit_card_expiration_date: "04/26", result: 0)
transaction3 = invoice3.transactions.create!(credit_card_number: 1238634646123476, credit_card_expiration_date: "04/26", result: 0)
transaction4 = invoice4.transactions.create!(credit_card_number: 1238634646123476, credit_card_expiration_date: "04/26", result: 0)
