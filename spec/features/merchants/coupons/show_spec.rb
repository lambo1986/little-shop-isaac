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
end
# (Note: "use" of a coupon should be limited to successful transactions.)
