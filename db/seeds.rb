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

  merchant3 = Merchant.create!(name: "Sweetwater")
  merchant4 = Merchant.create!(name: "Etsy")
  coupon11 = merchant3.coupons.create!(name: "Millionaire", code: "MILLION", percent_off: , dollar_off: 1000000, active: true)
  coupon12 = merchant4.coupons.create!(name: "77%", code: "LUCKY7", percent_off: 77, dollar_off: 0, active: true)
  coupon13 = merchant4.coupons.create!(name: "111 Bucks Off", code: "111OFF", percent_off: 0, dollar_off: 100, active: true)
  coupon14 = merchant3.coupons.create!(name: "Luck Threes", code: "33OFF", percent_off: 33, dollar_off: 0, active: true)
  coupon15 = merchant3.coupons.create!(name: "25 % Off", code: "TAKE25", percent_off: 20, dollar_off: 0, active: true)
  item9 = merchant3.items.create!(name: "zoozoo", description: "music", unit_price: 111)
  item10 = merchant3.items.create!(name: "gummy donks", description: "candy", unit_price: 153)
  item11 = merchant4.items.create!(name: "Big Screen Calculator", description: "school", unit_price: 12343)
  item12 = merchant4.items.create!(name: "nubbs", description: "kids", unit_price: 365)
  item13 = merchant3.items.create!(name: "stuffed pig", description: "valentines", unit_price: 5777)
  item14 = merchant3.items.create!(name: "ping pong", description: "games", unit_price: 21132)
  item15 = merchant3.items.create!(name: "karate glove", description: "sports", unit_price: 7500)
  item16 = merchant4.items.create!(name: "frog eggs", description: "pets", unit_price: 45454)
  customer4 = Customer.create!(first_name: "John", last_name: "Smith")
  customer5 = Customer.create!(first_name: "Jack", last_name: "Sams")
  customer6 = Customer.create!(first_name: "Bertha", last_name: "Bartholomew")
  invoice16 = coupon11.invoices.create!(status: 2, customer: customer4)
  invoice17 = coupon12.invoices.create!(status: 0, customer: customer4)
  invoice18 = coupon13.invoices.create!(status: 1, customer: customer4)
  invoice19 = coupon14.invoices.create!(status: 2, customer: customer5)
  invoice20 = coupon15.invoices.create!(status: 2, customer: customer6)
  invoice_item21 = invoice16.invoice_items.create!(item_id: item9.id, quantity: 1, unit_price: 111, status: 0)
  invoice_item22 = invoice16.invoice_items.create!(item_id: item10.id, quantity: 2, unit_price: 153, status: 1)
  invoice_item23 = invoice16.invoice_items.create!(item_id: item11.id, quantity: 1, unit_price: 12343, status: 2)
  invoice_item24 = invoice17.invoice_items.create!(item_id: item12.id, quantity: 6, unit_price: 365, status: 1)
  invoice_item25 = invoice18.invoice_items.create!(item_id: item13.id, quantity: 1, unit_price: 5777, status: 2)
  invoice_item26 = invoice19.invoice_items.create!(item_id: item13.id, quantity: 1, unit_price: 5777, status: 2)
  invoice_item27 = invoice19.invoice_items.create!(item_id: item14.id, quantity: 7, unit_price: 21132, status: 0)
  invoice_item28 = invoice19.invoice_items.create!(item_id: item16.id, quantity: 1, unit_price: 7500, status: 2)
  invoice_item29 = invoice19.invoice_items.create!(item_id: item16.id, quantity: 13, unit_price: 45454, status: 2)
  transaction16 = invoice16.transactions.create!(credit_card_number: 8765567890123476, credit_card_expiration_date: "04/26", result: 0)
  transaction17 = invoice17.transactions.create!(credit_card_number: 7656567590123476, credit_card_expiration_date: "04/26", result: 1)
  transaction18 = invoice18.transactions.create!(credit_card_number: 4565634646123476, credit_card_expiration_date: "04/26", result: 0)
  transaction19 = invoice19.transactions.create!(credit_card_number: 5434634646123476, credit_card_expiration_date: "04/26", result: 0)
  transaction20 = invoice20.transactions.create!(credit_card_number: 2342634646123476, credit_card_expiration_date: "04/26", result: 0)

  merchant1 = Merchant.create!(name: "Walmart")
  merchant2 = Merchant.create!(name: "Temu")
  coupon1 = merchant1.coupons.create!(name: "Buy One Get One 50%", code: "BOGO50", percent_off: 50, dollar_off: 0, active: true)
  coupon4 = merchant1.coupons.create!(name: "Nothing Off", code: "NOTHING", percent_off: 0, dollar_off: 0, active: true)
  coupon3 = merchant2.coupons.create!(name: "100 Bucks Off", code: "100OFF", percent_off: 0, dollar_off: 100, active: true)
  coupon2 = merchant2.coupons.create!(name: "10 Bucks Off", code: "10OFF", percent_off: 0, dollar_off: 10, active: true)
  coupon5 = merchant1.coupons.create!(name: "20 % Off", code: "TAKE20", percent_off: 20, dollar_off: 0, active: true)
  coupon6 = merchant1.coupons.create!(name: "30 % Off", code: "TAKE30", percent_off: 30, dollar_off: 0, active: true)
  coupon7 = merchant1.coupons.create!(name: "40 % Off", code: "TAKE40", percent_off: 40, dollar_off: 0, active: true)
  coupon8 = merchant2.coupons.create!(name: "50 % Off", code: "TAKE50", percent_off: 50, dollar_off: 0, active: true)
  coupon9 = merchant2.coupons.create!(name: "60 % Off", code: "TAKE60", percent_off: 60, dollar_off: 0, active: true)
  coupon10 = merchant2.coupons.create!(name: "70 % Off", code: "TAKE70", percent_off: 70, dollar_off: 0, active: true)
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
  invoice1 = coupon5.invoices.create!(status: 2, customer: customer1)
  invoice2 = coupon5.invoices.create!(status: 0, customer: customer1)
  invoice3 = coupon5.invoices.create!(status: 1, customer: customer1)
  invoice4 = coupon2.invoices.create!(status: 2, customer: customer2)
  invoice5 = coupon2.invoices.create!(status: 2, customer: customer3)
  invoice6 = coupon1.invoices.create!(status: 2, customer: customer2)
  invoice7 = coupon9.invoices.create!(status: 2, customer: customer1)
  invoice8 = coupon9.invoices.create!(status: 2, customer: customer3)
  invoice9 = coupon9.invoices.create!(status: 2, customer: customer3)
  invoice10 = coupon9.invoices.create!(status: 2, customer: customer2)
  invoice11 = coupon8.invoices.create!(status: 2, customer: customer2)
  invoice12 = coupon8.invoices.create!(status: 2, customer: customer1)
  invoice13 = coupon8.invoices.create!(status: 2, customer: customer3)
  invoice14 = coupon7.invoices.create!(status: 2, customer: customer1)
  invoice15 = coupon7.invoices.create!(status: 2, customer: customer3)
  invoice_item1 = invoice1.invoice_items.create!(item_id: item1.id, quantity: 1, unit_price: 100, status: 0)
  invoice_item2 = invoice1.invoice_items.create!(item_id: item2.id, quantity: 2, unit_price: 87877, status: 1)
  invoice_item3 = invoice1.invoice_items.create!(item_id: item3.id, quantity: 1, unit_price: 776, status: 2)
  invoice_item4 = invoice2.invoice_items.create!(item_id: item4.id, quantity: 6, unit_price: 2, status: 1)
  invoice_item5 = invoice3.invoice_items.create!(item_id: item5.id, quantity: 1, unit_price: 5986, status: 2)
  invoice_item6 = invoice4.invoice_items.create!(item_id: item5.id, quantity: 1, unit_price: 545, status: 2)
  invoice_item7 = invoice4.invoice_items.create!(item_id: item6.id, quantity: 7, unit_price: 65454, status: 0)
  invoice_item8 = invoice5.invoice_items.create!(item_id: item7.id, quantity: 1, unit_price: 5352, status: 2)
  invoice_item9 = invoice6.invoice_items.create!(item_id: item8.id, quantity: 13, unit_price: 3765, status: 2)
  invoice_item10 = invoice6.invoice_items.create!(item_id: item1.id, quantity: 13, unit_price: 54, status: 2)
  invoice_item11 = invoice7.invoice_items.create!(item_id: item7.id, quantity: 14, unit_price: 5654, status: 2)
  invoice_item12 = invoice8.invoice_items.create!(item_id: item4.id, quantity: 1, unit_price: 675765, status: 2)
  invoice_item13 = invoice9.invoice_items.create!(item_id: item3.id, quantity: 143, unit_price: 74567456, status: 2)
  invoice_item14 = invoice10.invoice_items.create!(item_id: item8.id, quantity: 63, unit_price: 2354, status: 2)
  invoice_item15 = invoice11.invoice_items.create!(item_id: item5.id, quantity: 83, unit_price: 7456, status: 2)
  invoice_item16 = invoice13.invoice_items.create!(item_id: item8.id, quantity: 13, unit_price: 4565, status: 2)
  invoice_item17 = invoice14.invoice_items.create!(item_id: item2.id, quantity: 3, unit_price: 254, status: 2)
  invoice_item18 = invoice15.invoice_items.create!(item_id: item6.id, quantity: 173, unit_price: 765, status: 2)
  invoice_item19 = invoice12.invoice_items.create!(item_id: item6.id, quantity: 1378, unit_price: 3544, status: 2)
  transaction1 = invoice1.transactions.create!(credit_card_number: 1238567890123476, credit_card_expiration_date: "04/26", result: 0)
  transaction2 = invoice2.transactions.create!(credit_card_number: 6754856759012347, credit_card_expiration_date: "04/26", result: 0)
  transaction3 = invoice3.transactions.create!(credit_card_number: 2458634646123476, credit_card_expiration_date: "04/26", result: 0)
  transaction4 = invoice4.transactions.create!(credit_card_number: 9878634646123476, credit_card_expiration_date: "04/26", result: 0)
  transaction5 = invoice5.transactions.create!(credit_card_number: 5788634646123476, credit_card_expiration_date: "04/26", result: 0)
  transaction6 = invoice6.transactions.create!(credit_card_number: 6538634646123476, credit_card_expiration_date: "04/26", result: 0)
  transaction7 = invoice7.transactions.create!(credit_card_number: 8586346434234769, credit_card_expiration_date: "04/26", result: 0)
  transaction8 = invoice8.transactions.create!(credit_card_number: 2435863464612347, credit_card_expiration_date: "04/26", result: 0)
  transaction9 = invoice9.transactions.create!(credit_card_number: 2468634646123476, credit_card_expiration_date: "04/26", result: 0)
  transaction10 = invoice10.transactions.create!(credit_card_number: 7566468634646123, credit_card_expiration_date: "04/26", result: 0)
  transaction11 = invoice11.transactions.create!(credit_card_number: 7686346461234765, credit_card_expiration_date: "04/26", result: 0)
  transaction12 = invoice12.transactions.create!(credit_card_number: 4356634646123476, credit_card_expiration_date: "04/26", result: 0)
  transaction13 = invoice13.transactions.create!(credit_card_number: 6558634646123476, credit_card_expiration_date: "04/26", result: 0)
  transaction14 = invoice14.transactions.create!(credit_card_number: 7658634646123476, credit_card_expiration_date: "04/26", result: 0)
  transaction15 = invoice15.transactions.create!(credit_card_number: 8768634646123476, credit_card_expiration_date: "04/26", result: 0)
