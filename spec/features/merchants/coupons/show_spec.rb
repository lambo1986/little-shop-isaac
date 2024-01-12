require "rails_helper"

RSpec.describe "Merchant's coupons show page", type: :feature do
  it "shows the name, code percent/ dollar off and status and how many times the coupon has been used" do #US-3
    merchant1 = Merchant.create!(name: "Sweetwater", status: :enabled)
    bob = Customer.create!(first_name: "Bob", last_name: "Smith")
    jerry = Customer.create!(first_name: "Jerry", last_name: "Jones")
    tina = Customer.create!(first_name: "Tina", last_name: "Turner")
    coupon1 = merchant1.coupons.create!(name: "Buy One Get One 50%", code: "BOGO50", percent_off: 50, dollar_off: 0, active: true)
    invoice1 = coupon1.invoices.create!(status: 2, customer: bob)
    invoice2 = coupon1.invoices.create!(status: 2, customer: jerry)
    invoice3 = coupon1.invoices.create!(status: 2, customer: tina)
    transaction1 = invoice1.transactions.create!(credit_card_number: "1234567854", credit_card_expiration_date: "12/20", result: 0)
    transaction2 = invoice2.transactions.create!(credit_card_number: "1236785476", credit_card_expiration_date: "12/23", result: 0)
    transaction2 = invoice3.transactions.create!(credit_card_number: "1236785498", credit_card_expiration_date: "12/22", result: 1)#failed

    visit "/merchants/#{merchant1.id}/coupons/#{coupon1.id}"

    expect(page).to have_content("Coupon: Buy One Get One 50%")
    expect(page).to have_content("Code: BOGO50")
    expect(page).to have_content("% Off: 50")
    expect(page).to have_content("$ Off: 0")
    expect(page).to have_content("Active? true")
    expect(page).to have_content("Times Used: 2")
  end

  describe "when the coupon is not active" do
    it "shows the attributes of the coupon, but won't have a deactivate button" do #US-4
      merchant1 = Merchant.create!(name: "Sweetwater", status: :enabled)
      bob = Customer.create!(first_name: "Bob", last_name: "Smith")
      coupon1 = merchant1.coupons.create!(name: "Buy One Get One 50%", code: "BOGO50", percent_off: 50, dollar_off: 0, active: false)
      invoice1 = coupon1.invoices.create!(status: 2, customer: bob)
      transaction1 = invoice1.transactions.create!(credit_card_number: "1234567854", credit_card_expiration_date: "12/20", result: 0)

      visit "/merchants/#{merchant1.id}/coupons/#{coupon1.id}"

      expect(page).to have_content("Coupon: Buy One Get One 50%")
      expect(page).to have_content("Active? false")
      expect(page).to_not have_button("deactivate")
    end

    it "has a button to activate the coupon" do #US-5
      merchant1 = Merchant.create!(name: "Sweetwater", status: :enabled)
      bob = Customer.create!(first_name: "Bob", last_name: "Smith")
      coupon1 = merchant1.coupons.create!(name: "Buy One Get One 50%", code: "BOGO50", percent_off: 50, dollar_off: 0, active: false)
      invoice1 = coupon1.invoices.create!(status: 2, customer: bob)
      transaction1 = invoice1.transactions.create!(credit_card_number: "1234567854", credit_card_expiration_date: "12/20", result: 0)

      visit "/merchants/#{merchant1.id}/coupons/#{coupon1.id}"

      expect(page).to have_content("Coupon: Buy One Get One 50%")
      expect(page).to have_content("Active? false")
      expect(page).to have_button("activate")

      click_button("activate")

      expect(current_path).to eq("/merchants/#{merchant1.id}/coupons/#{coupon1.id}")
      expect(page).to have_content("update successful")
      expect(page).to have_content("Coupon: Buy One Get One 50%")
      expect(page).to have_content("Active? true")
      expect(page).to have_button("deactivate")
    end
  end

  describe "when the coupon is active" do
    it "has a button to deactivate the coupon" do #US-4
      merchant1 = Merchant.create!(name: "Sweetwater", status: :enabled)
      bob = Customer.create!(first_name: "Bob", last_name: "Smith")
      coupon1 = merchant1.coupons.create!(name: "Buy One Get One 50%", code: "BOGO50", percent_off: 50, dollar_off: 0, active: true)
      invoice1 = coupon1.invoices.create!(status: 2, customer: bob)
      transaction1 = invoice1.transactions.create!(credit_card_number: "1234567854", credit_card_expiration_date: "12/20", result: 0)

      visit "/merchants/#{merchant1.id}/coupons/#{coupon1.id}"

      expect(page).to have_content("Coupon: Buy One Get One 50%")
      expect(page).to have_content("Active? true")
      expect(page).to have_button("deactivate")

      click_button("deactivate")

      expect(current_path).to eq("/merchants/#{merchant1.id}/coupons/#{coupon1.id}")
      expect(page).to have_content("update successful")
      expect(page).to have_content("Coupon: Buy One Get One 50%")
      expect(page).to have_content("Active? false")
      expect(page).to_not have_button("deactivate")
    end

    it "when deactivating, throws an error if the coupon has an invoice that is pending" do #US-4 (0 == pending for invoice)
      merchant1 = Merchant.create!(name: "Sweetwater", status: :enabled)
      bob = Customer.create!(first_name: "Bob", last_name: "Smith")
      jane = Customer.create!(first_name: "Jane", last_name: "Wayne")
      coupon1 = merchant1.coupons.create!(name: "Buy One Get One 50%", code: "BOGO50", percent_off: 50, dollar_off: 0, active: true)
      invoice1 = coupon1.invoices.create!(status: 0, customer: bob)
      invoice1 = coupon1.invoices.create!(status: 2, customer: jane)# adds stability to test
      transaction1 = invoice1.transactions.create!(credit_card_number: "1234567854", credit_card_expiration_date: "12/20", result: 0)

      visit "/merchants/#{merchant1.id}/coupons/#{coupon1.id}"

      expect(page).to have_content("Coupon: Buy One Get One 50%")
      expect(page).to have_content("Active? true")
      expect(page).to have_button("deactivate")

      click_button("deactivate")

      expect(current_path).to eq("/merchants/#{merchant1.id}/coupons/#{coupon1.id}")
      expect(page).to have_content("update failed do to pending invoice")
      expect(page).to have_content("Coupon: Buy One Get One 50%")
      expect(page).to have_content("Active? true")
      expect(page).to have_button("deactivate")
    end
  end
end
