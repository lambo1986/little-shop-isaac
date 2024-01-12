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
end
