require "rails_helper"

RSpec.describe "new merchant's coupon page", type: :feature do #US-2
  it "can make a new merchant's coupon" do
    merchant1 = Merchant.create!(name: "Sweetwater", status: :enabled)

    visit "/merchants/#{merchant1.id}/coupons/new"

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
  end

  it "should not create a coupon if any field is blank" do #US-2
    merchant1 = Merchant.create!(name: "Sweetwater", status: :enabled)

    visit "/merchants/#{merchant1.id}/coupons/new"

    expect(current_path).to eq("/merchants/#{merchant1.id}/coupons/new")
    expect(page).to have_content("New Coupon for #{merchant1.name}:")

    fill_in "coupon_name", with: "25% Off"
    fill_in "coupon_code", with: ""
    fill_in "coupon_percent_off", with: 25
    fill_in "coupon_dollar_off", with: 0

    click_button "Create Coupon"

    expect(current_path).to eq("/merchants/#{merchant1.id}/coupons/new")
    expect(page).to have_content("All fields are required.")
  end

  it "should not create a coupon if the coupon code is not unique" do #US-2
    merchant1 = Merchant.create!(name: "Sweetwater", status: :enabled)
    coupon1 = merchant1.coupons.create!(name: "Buy One Get One 50%", code: "BOGO50", percent_off: 50, dollar_off: 0, active: true)

    visit "/merchants/#{merchant1.id}/coupons/new"

    fill_in "coupon_name", with: "Buy One Get One 50%"
    fill_in "coupon_code", with: "BOGO50"
    fill_in "coupon_percent_off", with: 50
    fill_in "coupon_dollar_off", with: 0

    click_button "Create Coupon"

    expect(current_path).to eq("/merchants/#{merchant1.id}/coupons/new")
    expect(page).to have_content("Unique coupon code required.")
  end

  it "should not create a coupon if merchant has 5 active coupons" do #US-2
    merchant1 = Merchant.create!(name: "Sweetwater", status: :enabled)
    coupon1 = merchant1.coupons.create!(name: "Buy One Get One 50%", code: "BOGO50", percent_off: 50, dollar_off: 0, active: true)
    coupon2 = merchant1.coupons.create!(name: "15 Dollars Off", code: "15BUCKS", percent_off: 0, dollar_off: 15, active: true)
    coupon3 = merchant1.coupons.create!(name: "15 Percent Off", code: "15PERCENT", percent_off: 15, dollar_off: 0, active: true)
    coupon4 = merchant1.coupons.create!(name: "25 Percent Off", code: "25PERCENT", percent_off: 25, dollar_off: 0, active: true)
    coupon5 = merchant1.coupons.create!(name: "30% Off", code: "GET30%", percent_off: 30, dollar_off: 0, active: true)

    visit "/merchants/#{merchant1.id}/coupons/new"

    fill_in "coupon_name", with: "Free!!!"
    fill_in "coupon_code", with: "TAKE100"
    fill_in "coupon_percent_off", with: 100
    fill_in "coupon_dollar_off", with: 0

    click_button "Create Coupon"

    expect(current_path).to eq("/merchants/#{merchant1.id}/coupons/new")
    expect(page).to have_content("Only 5 active coupons can be used at a time.")
  end
end
