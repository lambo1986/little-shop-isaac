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

    fill_in "coupon_name", with: "25% Off"
    fill_in "coupon_code", with: "GET25%"
    fill_in "coupon_percent_off", with: 25
    fill_in "coupon_dollar_off", with: 0

    click_button "Create Coupon"

    expect(current_path).to eq("/merchants/#{merchant1.id}/coupons")
    expect(page).to have_content("Coupon was successfully created.")
    expect(page).to have_content("Sweetwater's Coupons:")
    expect(page).to have_content(("25% Off"))
    expect(page).to have_link("Create New Coupon")

    click_link "Create New Coupon"

    expect(current_path).to eq("/merchants/#{merchant1.id}/coupons/new")
    expect(page).to have_content("New Coupon for #{merchant1.name}:")

    fill_in "coupon_name", with: "25% Off"
    fill_in "coupon_code", with: "GET25%"
    fill_in "coupon_percent_off", with: 25
    fill_in "coupon_dollar_off", with: 0

    click_button "Create Coupon"

    expect(current_path).to eq("/merchants/#{merchant1.id}/coupons/new")

    expect(page).to have_content("Error: all fields are required or must be unique.") #need to come back to this
  end
  # * Sad Paths to consider:
  # 1. This Merchant already has 5 active coupons
  # 2. Coupon code entered is NOT unique
end
