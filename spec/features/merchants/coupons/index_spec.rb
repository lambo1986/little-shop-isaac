require "rails_helper"

RSpec.describe "merchant's coupons index", type: :feature do #US-1
  it "lists the merchant's coupons" do
    merchant1 = Merchant.create!(name: "Sweetwater", status: :enabled)
    coupon1 = merchant1.coupons.create!(name: "Buy One Get One 50%", code: "BOGO50", percent_off: 50, dollar_off: 0, active: true)
    coupon2 = merchant1.coupons.create!(name: "15 Dollars Off", code: "15BUCKS", percent_off: 0, dollar_off: 15, active: true)
    coupon3 = merchant1.coupons.create!(name: "15 Percent Off", code: "15PERCENT", percent_off: 15, dollar_off: 0, active: true)

    visit "/merchants/#{merchant1.id}/coupons"

    expect(page).to have_content("Sweetwater's Coupons:")
    expect(page).to have_content(coupon1.name)
    expect(page).to have_content(coupon2.name)
    expect(page).to have_content(coupon3.name)
    expect(page).to have_content(coupon1.code)
    expect(page).to have_content(coupon2.code)
    expect(page).to have_content(coupon3.code)
    expect(page).to have_content(coupon1.percent_off.to_s)
    expect(page).to have_content(coupon2.percent_off.to_s)
    expect(page).to have_content(coupon3.percent_off.to_s)
    expect(page).to have_content(coupon1.dollar_off.to_s)
    expect(page).to have_content(coupon2.dollar_off.to_s)
    expect(page).to have_content(coupon3.dollar_off.to_s)
    expect(page).to have_content(coupon1.active.to_s)
    expect(page).to have_content(coupon2.active.to_s)
    expect(page).to have_content(coupon3.active.to_s)
    expect(page).to have_link(coupon1.name)
    expect(page).to have_link(coupon2.name)
    expect(page).to have_link(coupon3.name)

    click_link coupon1.name

    expect(current_path).to eq("/merchants/#{merchant1.id}/coupons/#{coupon1.id}")
  end

  it "has a link to create a new merchant coupon" do #US-2
    merchant1 = Merchant.create!(name: "Sweetwater", status: :enabled)
    coupon1 = merchant1.coupons.create!(name: "Buy One Get One 50%", code: "BOGO50", percent_off: 50, dollar_off: 0, active: true)
    coupon2 = merchant1.coupons.create!(name: "15 Dollars Off", code: "15BUCKS", percent_off: 0, dollar_off: 15, active: true)
    coupon3 = merchant1.coupons.create!(name: "15 Percent Off", code: "15PERCENT", percent_off: 15, dollar_off: 0, active: true)

    visit "/merchants/#{merchant1.id}/coupons"

    expect(page).to have_link("Create New Coupon")

    click_link "Create New Coupon"

    expect(current_path).to eq("/merchants/#{merchant1.id}/coupons/new")
    expect(page).to have_content("New Coupon for #{merchant1.name}:")
  end

  it "has sections for active and inactive coupons" do #US-6
    merchant1 = Merchant.create!(name: "Sweetwater", status: :enabled)
    coupon1 = merchant1.coupons.create!(name: "Buy One Get One 50%", code: "BOGO50", percent_off: 50, dollar_off: 0, active: true)
    coupon2 = merchant1.coupons.create!(name: "15 Dollars Off", code: "15BUCKS", percent_off: 0, dollar_off: 15, active: true)
    coupon3 = merchant1.coupons.create!(name: "15 Percent Off", code: "15PERCENT", percent_off: 15, dollar_off: 0, active: true)
    coupon4 = merchant1.coupons.create!(name: "25 Percent Off", code: "25PERCENT", percent_off: 25, dollar_off: 0, active: true)
    coupon5 = merchant1.coupons.create!(name: "30% Off", code: "GET30%", percent_off: 30, dollar_off: 0, active: true)
    coupon6 = merchant1.coupons.create!(name: "10% For Labor", code: "LABORDAY", percent_off: 10, dollar_off: 0, active: false)
    coupon7 = merchant1.coupons.create!(name: "Final Answer?", code: "MILLIONAIRE", percent_off: 0, dollar_off: 1000000, active: false)
    coupon8 = merchant1.coupons.create!(name: "$50 Towards Purchase", code: "BIGFIVEOHYEAH", percent_off: 0, dollar_off: 50, active: false)
    coupon9 = merchant1.coupons.create!(name: "1% Off", code: "PENNIESFROMHEAVEN", percent_off: 1, dollar_off: 0, active: false)
    coupon10 = merchant1.coupons.create!(name: "99% Off", code: "WEARETHE99", percent_off: 99, dollar_off: 0, active: false)

    visit "/merchants/#{merchant1.id}/coupons"

    expect(page).to have_content("Sweetwater's Coupons:")

    within "#active-coupons" do
      expect(page).to have_link(coupon1.name)
      expect(page).to have_link(coupon2.name)
      expect(page).to have_link(coupon3.name)
      expect(page).to have_link(coupon4.name)
      expect(page).to have_link(coupon5.name)
    end

    within "#inactive-coupons" do
      expect(page).to have_link(coupon6.name)
      expect(page).to have_link(coupon7.name)
      expect(page).to have_link(coupon8.name)
      expect(page).to have_link(coupon9.name)
      expect(page).to have_link(coupon10.name)
    end
  end

  it "shows the coupons for the merchant, sorted by popularity, descending, in both sections (active or inactive)" do #ext-1
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
    invoice_item2 = invoice1.invoice_items.create!(item_id: item2.id, quantity: 2, unit_price: 156, status: 1)
    invoice_item3 = invoice1.invoice_items.create!(item_id: item3.id, quantity: 1, unit_price: 243, status: 2)
    invoice_item4 = invoice2.invoice_items.create!(item_id: item4.id, quantity: 6, unit_price: 333, status: 1)
    invoice_item5 = invoice3.invoice_items.create!(item_id: item5.id, quantity: 1, unit_price: 5000, status: 2)
    invoice_item6 = invoice4.invoice_items.create!(item_id: item5.id, quantity: 1, unit_price: 5000, status: 2)
    invoice_item7 = invoice4.invoice_items.create!(item_id: item6.id, quantity: 7, unit_price: 200000, status: 0)
    invoice_item8 = invoice5.invoice_items.create!(item_id: item7.id, quantity: 1, unit_price: 7500, status: 2)
    invoice_item9 = invoice6.invoice_items.create!(item_id: item8.id, quantity: 13, unit_price: 3400, status: 2)
    invoice_item10 = invoice6.invoice_items.create!(item_id: item1.id, quantity: 13, unit_price: 3400, status: 2)
    invoice_item11 = invoice7.invoice_items.create!(item_id: item7.id, quantity: 13, unit_price: 3400, status: 2)
    invoice_item12 = invoice8.invoice_items.create!(item_id: item4.id, quantity: 13, unit_price: 3400, status: 2)
    invoice_item13 = invoice9.invoice_items.create!(item_id: item3.id, quantity: 13, unit_price: 3400, status: 2)
    invoice_item14 = invoice10.invoice_items.create!(item_id: item8.id, quantity: 13, unit_price: 3400, status: 2)
    invoice_item15 = invoice11.invoice_items.create!(item_id: item5.id, quantity: 13, unit_price: 3400, status: 2)
    invoice_item16 = invoice13.invoice_items.create!(item_id: item8.id, quantity: 13, unit_price: 3400, status: 2)
    invoice_item17 = invoice14.invoice_items.create!(item_id: item2.id, quantity: 13, unit_price: 3400, status: 2)
    invoice_item18 = invoice15.invoice_items.create!(item_id: item6.id, quantity: 13, unit_price: 3400, status: 2)
    invoice_item19 = invoice12.invoice_items.create!(item_id: item6.id, quantity: 13, unit_price: 3400, status: 2)
    transaction1 = invoice1.transactions.create!(credit_card_number: 1238567890123476, credit_card_expiration_date: "04/26", result: 0)
    transaction2 = invoice2.transactions.create!(credit_card_number: 6754856759012347, credit_card_expiration_date: "04/26", result: 0)
    transaction3 = invoice3.transactions.create!(credit_card_number: 2458634646123476, credit_card_expiration_date: "04/26", result: 0)
    transaction4 = invoice4.transactions.create!(credit_card_number: 9878634646123476, credit_card_expiration_date: "04/26", result: 0)
    transaction5 = invoice5.transactions.create!(credit_card_number: 5788634646123476, credit_card_expiration_date: "04/26", result: 0)
    transaction6 = invoice6.transactions.create!(credit_card_number: 6538634646123476, credit_card_expiration_date: "04/26", result: 0)
    transaction7 = invoice7.transactions.create!(credit_card_number: 8586346434234769, credit_card_expiration_date: "04/26", result: 0)
    transaction8 = invoice8.transactions.create!(credit_card_number: 2435863464612347, credit_card_expiration_date: "04/26", result: 0)
    transaction9 = invoice9.transactions.create!(credit_card_number: 2468634646123476, credit_card_expiration_date: "04/26", result: 0)
    transaction10 = invoice10.transactions.create!(credit_card_number: 2468634646123476, credit_card_expiration_date: "04/26", result: 0)
    transaction11 = invoice11.transactions.create!(credit_card_number: 2468634646123476, credit_card_expiration_date: "04/26", result: 0)
    transaction12 = invoice12.transactions.create!(credit_card_number: 2468634646123476, credit_card_expiration_date: "04/26", result: 0)
    transaction13 = invoice13.transactions.create!(credit_card_number: 2468634646123476, credit_card_expiration_date: "04/26", result: 0)
    transaction14 = invoice14.transactions.create!(credit_card_number: 2468634646123476, credit_card_expiration_date: "04/26", result: 0)
    transaction15 = invoice15.transactions.create!(credit_card_number: 2468634646123476, credit_card_expiration_date: "04/26", result: 0)

    visit "/merchants/#{merchant1.id}/coupons"

    expect(page).to have_content("Walmart's Coupons:")
    expect(page).to have_content(coupon1.name)
    expect(page).to have_content("Times Used: 1")
    expect(page).to have_content(coupon5.name)
    expect(page).to have_content("Times Used: 3")
    expect(coupon5.name).to appear_before(coupon1.name)
    expect(coupon5.name).to appear_before(coupon4.name)
    expect("Times Used: 3").to appear_before("Times Used: 1")
    expect("Times Used: 1").to appear_before("Times Used: 0")

    visit "/merchants/#{merchant2.id}/coupons"

    expect(page).to have_content("Temu's Coupons:")

    within("#active-coupons") do
      expect(page).to have_content(coupon9.name)
      expect(page).to have_content("Times Used: 4")
      expect(page).to have_content(coupon2.name)
      expect(page).to have_content("Times Used: 2")
      expect(page).to have_content(coupon3.name)
      expect(page).to have_content("Times Used: 0")
      expect(coupon9.name).to appear_before(coupon2.name)
      expect(coupon2.name).to appear_before(coupon3.name)
      expect("Times Used: 2").to appear_before("Times Used: 0")
    end

      visit "/merchants/#{merchant2.id}/coupons/#{coupon9.id}"
      click_button "deactivate"
      visit "/merchants/#{merchant2.id}/coupons/#{coupon3.id}"
      click_button "deactivate"
      visit "/merchants/#{merchant2.id}/coupons/#{coupon10.id}"
      click_button "deactivate"
      visit "/merchants/#{merchant2.id}/coupons/#{coupon2.id}"
      click_button "deactivate"

    visit "/merchants/#{merchant2.id}/coupons"

    expect(page).to have_content("Temu's Coupons:")

    within("#inactive-coupons") do
      expect(page).to have_content(coupon9.name)
      expect(page).to have_content("Times Used: 4")
      expect(page).to have_content(coupon2.name)
      expect(page).to have_content("Times Used: 2")
      expect(page).to have_content(coupon3.name)
      expect(page).to have_content("Times Used: 0")
      expect(page).to have_content(coupon10.name)
      expect(page).to have_content("Times Used: 0")
      expect(coupon9.name).to appear_before(coupon2.name)
      expect(coupon2.name).to appear_before(coupon10.name)
      expect("Times Used: 4").to appear_before("Times Used: 0")
      expect("Times Used: 2").to appear_before("Times Used: 0")
      expect("Times Used: 4").to appear_before("Times Used: 2")
    end
  end
end
