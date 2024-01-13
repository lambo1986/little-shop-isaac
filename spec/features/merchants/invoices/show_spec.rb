require "rails_helper"

RSpec.describe "merchant's invoice page", type: :feature do
  it "shows the invoice status and ID, and date formatted like 'Monday, July 18, 2019' and customer full name" do
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

    visit merchant_invoice_path(merchant_1, invoice1)

    expect(current_path).to eq("/merchants/#{merchant_1.id}/invoices/#{invoice1.id}")

    expect(page).to have_content(invoice1.id)
    expect(page).to have_content(invoice1.status)
    expect(page).to have_content(invoice1.created_at.strftime("%A, %B %d, %Y"))
    expect(page).to have_content(invoice1.customer.first_name + " " + invoice1.customer.last_name)
  end

  it "lists all items on invoice including: name, quantity, price, status and I do not see any information related to Items for other merchants" do
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

    visit merchant_invoice_path(merchant_1, invoice1)

    expect(current_path).to eq("/merchants/#{merchant_1.id}/invoices/#{invoice1.id}")

    expect(page).to have_content("Item Information:")
    expect(page).to have_content(item1.name)
    expect(page).to have_content(item2.name)
    expect(page).to_not have_content(item3.name)
    expect(page).to have_content(invoice_item1.quantity)
    expect(page).to have_content(invoice_item2.quantity)
    expect(page).to have_content(invoice_item1.unit_price.to_f / 100)
    expect(page).to have_content(invoice_item2.unit_price.to_f / 100)
    expect(page).to have_content(invoice_item1.status)
    expect(page).to have_content(invoice_item2.status)
  end

  it "shows the total revenue that will be generated from all of my items on the invoice" do
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

    visit merchant_invoice_path(merchant_1, invoice1)

    expect(current_path).to eq("/merchants/#{merchant_1.id}/invoices/#{invoice1.id}")

    expect(page).to have_content("Total Expected Revenue: $#{merchant_1.total_invoice_revenue(invoice1).to_f / 100}") #365
  end

  it "the invoice item status is a select box and can change the invoice_items status" do
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

    visit merchant_invoice_path(merchant_1, invoice1)
    expect(current_path).to eq("/merchants/#{merchant_1.id}/invoices/#{invoice1.id}")
    expect(page).to have_content("Update Item Status")
    expect(page).to have_content("pending")

    select "Packaged", from: :status
    click_button "Update Item Status"
    expect(current_path).to eq("/merchants/#{merchant_1.id}/invoices/#{invoice1.id}")
    expect(page).to have_content("Pending")
  end

  it "shows the subtotal and grand total revenues and the coupon name as a link to it's show" do# US-7
    merchant1 = Merchant.create!(name: "Walmart")
    merchant2 = Merchant.create!(name: "Temu")
    coupon1 = merchant1.coupons.create!(name: "Buy One Get One 50%", code: "BOGO50", percent_off: 50, dollar_off: 0, active: true)
    item1 = merchant1.items.create!(name: "popcan", description: "fun", unit_price: 100)
    item2 = merchant1.items.create!(name: "popper", description: "fun", unit_price: 156)
    item3 = merchant2.items.create!(name: "copper", description: "money", unit_price: 243)
    customer1 = Customer.create!(first_name: "John", last_name: "Smith")
    invoice1 = coupon1.invoices.create!(status: 2, customer: customer1)#total $4.12 for merchant1
    invoice_item1 = invoice1.invoice_items.create!(item_id: item1.id, quantity: 1, unit_price: 100, status: 0)#merchant1
    invoice_item2 = invoice1.invoice_items.create!(item_id: item2.id, quantity: 2, unit_price: 156, status: 1)#merchant1
    invoice_item3 = invoice1.invoice_items.create!(item_id: item3.id, quantity: 1, unit_price: 243, status: 2)#merchant2 (A coupon code from a Merchant only applies to Items sold by that Merchant)
    transaction1 = invoice1.transactions.create!(credit_card_number: 1238567890123476, credit_card_expiration_date: "04/26", result: 0)

    visit "/merchants/#{merchant1.id}/invoices/#{invoice1.id}"

    expect(page).to have_content("Total Expected Revenue: $#{merchant1.total_invoice_revenue(invoice1).to_f / 100} (Before Coupons)")
    expect(page).to have_content("Total Expected Revenue: $#{merchant1.revenue_after_coupons(invoice1).to_f / 100} (After Coupons)")
    expect(page).to have_link(coupon1.name + " " + coupon1.code)
  end
end
