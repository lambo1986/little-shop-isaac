require "rails_helper"

RSpec.describe "Merchants/Items Index Page", type: :feature do
  it "shows a list of all of my items and not for other merchants" do
    merchant_1 = Merchant.create!(name: "Walmart")
    merchant_2 = Merchant.create!(name: "Amazon")
    walmart_items = create_list(:item, 37, merchant_id: merchant_1.id)
    amazon_items = create_list(:item, 43, merchant_id: merchant_2.id)

    visit "/merchants/#{merchant_1.id}/items"

    walmart_items.each do |walmart_item|
      expect(page).to have_content(walmart_item.name)
    end

    amazon_items.each do |amazon_item|
      expect(page).to_not have_content(amazon_item.name)
    end

    visit "/merchants/#{merchant_2.id}/items"

    amazon_items.each do |amazon_item|
      expect(page).to have_content(amazon_item.name)
    end

    walmart_items.each do |walmart_item|
      expect(page).to_not have_content(walmart_item.name)
    end
  end

  it "has a disable/enable status and a link to change status next to each item" do
    merchant_1 = Merchant.create!(name: "Walmart")
    merchant_2 = Merchant.create!(name: "Amazon")
    walmart_items = create_list(:item, 37, merchant_id: merchant_1.id)
    amazon_items = create_list(:item, 43, merchant_id: merchant_2.id)

    visit "/merchants/#{merchant_1.id}/items"

    within "#item-#{merchant_1.items.first.id}" do
      expect(page).to have_content("enabled")
      expect(page).to have_button("enable")
      expect(page).to have_button("disable")
    end

    within "#item-#{merchant_1.items.last.id}" do
      expect(page).to have_content("enabled")
      expect(page).to have_button("enable")
      expect(page).to have_button("disable")

      click_button "disable"
    end

    expect(current_path).to eq("/merchants/#{merchant_1.id}/items")
    within "#item-#{merchant_1.items.last.id}" do
      expect(page).to have_content("disabled")
    end
  end

  it "has two sections, one for 'Enabled Items' and one for 'Disabled Items'" do
    merchant = Merchant.create!(name: "Snow-Globes and Used Clothing")
    items1 = create_list(:item, 23, merchant_id: merchant.id, status: "enabled")
    items2 = create_list(:item, 17, merchant_id: merchant.id, status: "disabled")
    items3 = create_list(:item, 11, merchant_id: merchant.id, status: "enabled")
    items4 = create_list(:item, 13, merchant_id: merchant.id, status: "disabled")

    visit "/merchants/#{merchant.id}/items"

    within('section#enabled-items') do
      expect(page).to have_content("Status: enabled")
      items1.each do |item|
        expect(page).to have_content(item.name)
      end

      items2.each do |item|
        expect(page).to have_content(item.name)
      end
    end

    within('section#disabled-items') do
      expect(page).to have_content("Status: disabled")
      items2.each do |item|
        expect(page).to have_content(item.name)
      end

      items4.each do |item|
        expect(page).to have_content(item.name)
      end
    end
  end
end
