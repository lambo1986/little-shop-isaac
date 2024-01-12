require 'rails_helper'

RSpec.describe 'Admin Merchants', type: :feature do

  before(:each) do
    @merch_1 = Merchant.create!(name: "Walmart", status: :enabled)
    @merch_2 = Merchant.create!(name: "Target", status: :disabled)
    @merch_3 = Merchant.create!(name: "PetSmart", status: :disabled)
    @merch_4 = Merchant.create!(name: "GameStop", status: :enabled)
    @merch_5 = Merchant.create!(name: "Sams", status: :enabled)
    @merch_6 = Merchant.create!(name: "Costco", status: :enabled)

    @item_1 = @merch_1.items.create!(name: "Apple", description: "red apple", unit_price:1)
    @item_2 = @merch_1.items.create!(name: "Orange", description: "orange orange", unit_price:1)
    @item_3 = @merch_2.items.create!(name: "Blood Orange", description: "blood orange", unit_price:1)
    @item_4 = @merch_2.items.create!(name: "Grape", description: "Red Grape", unit_price:1)
    @item_5 = @merch_3.items.create!(name: "Dragon fruit", description: "Red", unit_price:1)
    @item_6 = @merch_3.items.create!(name: "plum", description: "Good", unit_price:1)
    @item_7 = @merch_4.items.create!(name: "tacos", description: "tortilla", unit_price:1)
    @item_8 = @merch_4.items.create!(name: "gum", description: "mint", unit_price:1)
    @item_9 = @merch_5.items.create!(name: "pasta", description: "Italian", unit_price:1)
    @item_10 = @merch_5.items.create!(name: "Rum", description: "Yum", unit_price:1)
    @item_11 = @merch_6.items.create!(name: "Vodka", description: "White", unit_price:1)
    @item_12 = @merch_6.items.create!(name: "Cat Toy", description: "toy", unit_price:1)

    @cust_1 = Customer.create!(first_name: "Larry", last_name: "Johnson")
    @cust_2 = Customer.create!(first_name: "Pam", last_name: "Nelson")
    @cust_3 = Customer.create!(first_name: "Logan", last_name: "Finnegan")
    @cust_4 = Customer.create!(first_name: "Nate", last_name: "Lambertson")
    @cust_5 = Customer.create!(first_name: "Martin", last_name: "chavez")
    @cust_6 = Customer.create!(first_name: "Isaac", last_name: "Mitchell")

    @inv_1 = @cust_1.invoices.create!(status: :completed, created_at:Time.new(2021, 10, 31) )
    @inv_2 = @cust_2.invoices.create!(status: :completed,created_at:Time.new(2024, 12, 12))
    @inv_3 = @cust_3.invoices.create!(status: :completed, created_at:Time.new(2016, 10, 31))
    @inv_4 = @cust_4.invoices.create!(status: :completed,created_at:Time.new(1998, 10, 31))
    @inv_5 = @cust_5.invoices.create!(status: :in_progress,created_at:Time.new(2001, 02, 1))
    @inv_6 = @cust_6.invoices.create!(status: :cancelled, created_at:Time.new(2005, 10, 31))

    @tran_1 = @inv_1.transactions.create!(credit_card_number: "2222 2222 2222 2222", credit_card_expiration_date: "01/2021", result: :success )
    @tran_2 = @inv_2.transactions.create!(credit_card_number: "2222 2222 2222 2222", credit_card_expiration_date: "02/2022", result: :success )
    @tran_3 = @inv_3.transactions.create!(credit_card_number: "2222 2222 2222 2222", credit_card_expiration_date: "03/2023", result: :success )
    @tran_4 = @inv_4.transactions.create!(credit_card_number: "2222 2222 2222 2222", credit_card_expiration_date: "04/2024", result: :success )
    @tran_5 = @inv_5.transactions.create!(credit_card_number: "2222 2222 2222 2222", credit_card_expiration_date: "05/2025", result: :success )
    @tran_6 = @inv_6.transactions.create!(credit_card_number: "2222 2222 2222 2222", credit_card_expiration_date: "06/2026", result: :failed )

    @ii_1 = InvoiceItem.create!(invoice: @inv_1, item: @item_1, quantity: 10, unit_price: 1, status: :shipped )
    @ii_2 = InvoiceItem.create!(invoice: @inv_1, item: @item_2, quantity: 10, unit_price: 1, status: :shipped )
    @ii_3 = InvoiceItem.create!(invoice: @inv_1, item: @item_3, quantity: 10, unit_price: 1, status: :shipped )
    @ii_4 = InvoiceItem.create!(invoice: @inv_2, item: @item_1, quantity: 10, unit_price: 1, status: :shipped )
    @ii_5 = InvoiceItem.create!(invoice: @inv_2, item: @item_2, quantity: 10, unit_price: 1, status: :shipped )
    @ii_6 = InvoiceItem.create!(invoice: @inv_2, item: @item_3, quantity: 10, unit_price: 1, status: :shipped )
    @ii_7 = InvoiceItem.create!(invoice: @inv_3, item: @item_1, quantity: 10, unit_price: 1, status: :shipped )
    @ii_8 = InvoiceItem.create!(invoice: @inv_3, item: @item_2, quantity: 10, unit_price: 1, status: :shipped )
    @ii_9 = InvoiceItem.create!(invoice: @inv_3, item: @item_3, quantity: 10, unit_price: 1, status: :shipped )
    @ii_10 = InvoiceItem.create!(invoice: @inv_4, item: @item_1, quantity: 10, unit_price: 1, status: :shipped )
    @ii_11 = InvoiceItem.create!(invoice: @inv_4, item: @item_2, quantity: 10, unit_price: 1, status: :shipped )
    @ii_12 = InvoiceItem.create!(invoice: @inv_4, item: @item_3, quantity: 10, unit_price: 1, status: :shipped )
    @ii_13 = InvoiceItem.create!(invoice: @inv_5, item: @item_1, quantity: 10, unit_price: 1, status: :shipped )
    @ii_14 = InvoiceItem.create!(invoice: @inv_5, item: @item_2, quantity: 10, unit_price: 1, status: :shipped )
    @ii_15 = InvoiceItem.create!(invoice: @inv_5, item: @item_3, quantity: 10, unit_price: 1, status: :pending )
    @ii_16 = InvoiceItem.create!(invoice: @inv_6, item: @item_1, quantity: 10, unit_price: 1, status: :shipped )
    @ii_17 = InvoiceItem.create!(invoice: @inv_6, item: @item_2, quantity: 10, unit_price: 1, status: :shipped )
    @ii_18 = InvoiceItem.create!(invoice: @inv_6, item: @item_3, quantity: 10, unit_price: 1, status: :shipped )
    @ii_19 = InvoiceItem.create!(invoice: @inv_6, item: @item_4, quantity: 10, unit_price: 1, status: :pending )
    @ii_20 = InvoiceItem.create!(invoice: @inv_6, item: @item_5, quantity: 15, unit_price: 1, status: :shipped )
    @ii_21 = InvoiceItem.create!(invoice: @inv_6, item: @item_7, quantity: 13, unit_price: 1, status: :shipped )
    @ii_22 = InvoiceItem.create!(invoice: @inv_6, item: @item_9, quantity: 17, unit_price: 1, status: :shipped )
    @ii_23 = InvoiceItem.create!(invoice: @inv_6, item: @item_11, quantity: 2, unit_price: 1, status: :shipped )
  end

  it 'displays the name of each merchant' do
    visit admin_merchants_path
    within '.merchants-index' do
      expect(page).to have_content("Walmart")
      expect(page).to have_content("Target")
    end
  end

  # 27. Admin Merchant Enable/Disable
  it "can disable the merchant" do
    # When I visit the admin merchants index (/admin/merchants)
    visit admin_merchants_path
    # Then next to each merchant name I see a button to disable or enable that merchant.
    within "#merchant-#{@merch_1.id}" do
      expect(page).to have_button("disable")
      expect(page).to have_content("Status: Enabled")
    end

    within "#merchant-#{@merch_2.id}" do
      expect(page).to have_button("enable")
    end
    # When I click this button
    within "#merchant-#{@merch_1.id}" do
      click_button("disable")
    end
    # Then I am redirected back to the admin merchants index
    expect(current_path).to eq(admin_merchants_path)
    expect(page).to have_content("Update Successful")
    # And I see that the merchant's status has changed
    within "#merchant-#{@merch_1.id}" do
      expect(page).to have_button("enable")
      expect(page).to have_content("Status: Disabled")
    end

    within "#merchant-#{@merch_1.id}" do
    click_button("enable")
    end

    expect(current_path).to eq(admin_merchants_path)

    within "#merchant-#{@merch_1.id}" do
    expect(page).to have_button("disable")
    expect(page).to have_content("Status: Enabled")
  end

  end

  # User 28
  it "I see a section for Enabled Merchants" do
    visit admin_merchants_path

    within "#enabled_merch" do
      expect(page).to have_content(@merch_1.name)
      expect(page).to have_content(@merch_4.name)

      expect(page).to_not have_content(@merch_2.name)
      expect(page).to_not have_content(@merch_3.name)
    end
  end

  it "I see a section for disabled Merchants" do
    visit admin_merchants_path
    within "#disabled_merch" do
      expect(page).to have_content(@merch_2.name)
      expect(page).to have_content(@merch_3.name)

      expect(page).to_not have_content(@merch_1.name)
      expect(page).to_not have_content(@merch_4.name)
    end
  end

  # US 30
  it " sees the top 5 merchants by revenue" do

    inv1 = @cust_1.invoices.create!(status: :completed)
    inv2 = @cust_2.invoices.create!(status: :completed)
    inv3 = @cust_3.invoices.create!(status: :completed)
    inv4 = @cust_4.invoices.create!(status: :completed)
    inv5 = @cust_5.invoices.create!(status: :completed)
    inv6 = @cust_6.invoices.create!(status: :completed)

    tran1 = inv1.transactions.create!(credit_card_number: "2222 2222 2222 2222", credit_card_expiration_date: "01/2021", result: :success )
    tran2 = inv2.transactions.create!(credit_card_number: "2222 2222 2222 2222", credit_card_expiration_date: "02/2022", result: :success )
    tran3 = inv3.transactions.create!(credit_card_number: "2222 2222 2222 2222", credit_card_expiration_date: "03/2023", result: :success )
    tran4 = inv4.transactions.create!(credit_card_number: "2222 2222 2222 2222", credit_card_expiration_date: "04/2024", result: :success )
    tran5 = inv5.transactions.create!(credit_card_number: "2222 2222 2222 2222", credit_card_expiration_date: "05/2025", result: :success )
    tran6 = inv6.transactions.create!(credit_card_number: "2222 2222 2222 2222", credit_card_expiration_date: "06/2026", result: :success )

    ii1 = InvoiceItem.create!(invoice: inv1, item: @item_1, quantity: 1000, unit_price: 1, status: :shipped )
    ii2 = InvoiceItem.create!(invoice: inv2, item: @item_3, quantity: 250, unit_price: 1, status: :shipped )
    ii3 = InvoiceItem.create!(invoice: inv3, item: @item_5, quantity: 300, unit_price: 1, status: :shipped )
    ii4 = InvoiceItem.create!(invoice: inv4, item: @item_7, quantity: 100, unit_price: 1, status: :shipped )
    ii5 = InvoiceItem.create!(invoice: inv5, item: @item_9, quantity: 600, unit_price: 1, status: :shipped )
    ii6 = InvoiceItem.create!(invoice: inv6, item: @item_11, quantity: 10, unit_price: 1, status: :shipped )

    visit admin_merchants_path

    within ".top_5_revenue" do
      expect(page).to have_content("Walmart Revenue: $14300")
      expect(page).to have_content("Target Revenue: $2400")
      expect(page).to have_content("PetSmart Revenue: $600")
      expect(page).to have_content("GameStop Revenue: $200")
      expect(page).to have_content("Sams Revenue: $1200")
      expect(page).to_not have_content("Costco")

      expect(page).to have_link(@merch_1.name)
      expect(page).to have_link(@merch_2.name)
      expect(page).to have_link(@merch_3.name)
      expect(page).to have_link(@merch_4.name)
      expect(page).to have_link(@merch_5.name)
    end
  end

  it 'top_merchants best day' do
    inv1 = @cust_1.invoices.create!(status: :completed)
    inv2 = @cust_2.invoices.create!(status: :completed, created_at: Time.new(2022, 02, 02))
    inv3 = @cust_3.invoices.create!(status: :completed)
    inv4 = @cust_4.invoices.create!(status: :completed, created_at: Time.new(2011, 06, 03))
    inv5 = @cust_5.invoices.create!(status: :completed)
    inv6 = @cust_6.invoices.create!(status: :completed)

    tran1 = inv1.transactions.create!(credit_card_number: "2222 2222 2222 2222", credit_card_expiration_date: "01/2021", result: :success )
    tran2 = inv2.transactions.create!(credit_card_number: "2222 2222 2222 2222", credit_card_expiration_date: "02/2022", result: :success )
    tran3 = inv3.transactions.create!(credit_card_number: "2222 2222 2222 2222", credit_card_expiration_date: "03/2023", result: :success )
    tran4 = inv4.transactions.create!(credit_card_number: "2222 2222 2222 2222", credit_card_expiration_date: "04/2024", result: :success )
    tran5 = inv5.transactions.create!(credit_card_number: "2222 2222 2222 2222", credit_card_expiration_date: "05/2025", result: :success )
    tran6 = inv6.transactions.create!(credit_card_number: "2222 2222 2222 2222", credit_card_expiration_date: "06/2026", result: :success )

    ii1 = InvoiceItem.create!(invoice: inv1, item: @item_1, quantity: 1000, unit_price: 1, status: :shipped )
    ii2 = InvoiceItem.create!(invoice: inv2, item: @item_3, quantity: 250, unit_price: 1, status: :shipped )
    ii3 = InvoiceItem.create!(invoice: inv3, item: @item_5, quantity: 300, unit_price: 1, status: :shipped )
    ii4 = InvoiceItem.create!(invoice: inv4, item: @item_7, quantity: 100, unit_price: 1, status: :shipped )
    ii5 = InvoiceItem.create!(invoice: inv5, item: @item_9, quantity: 600, unit_price: 1, status: :shipped )
    ii6 = InvoiceItem.create!(invoice: inv6, item: @item_11, quantity: 10, unit_price: 1, status: :shipped )

    #   When I visit the admin merchants index
    visit admin_merchants_path
    #   Then next to each of the 5 merchants by revenue I see the date with the most revenue for each merchant.
    expect(page).to have_content("Top selling date for #{@merch_1.name} was #{inv1.created_at.strftime("%m/%d/%y")}")
    expect(page).to have_content("Top selling date for #{@merch_2.name} was #{inv2.created_at.strftime("%m/%d/%y")}")
    expect(page).to have_content("Top selling date for #{@merch_3.name} was #{inv3.created_at.strftime("%m/%d/%y")}")
    expect(page).to have_content("Top selling date for #{@merch_4.name} was #{@inv_6.created_at.strftime("%m/%d/%y")}")
    expect(page).to have_content("Top selling date for #{@merch_5.name} was #{inv5.created_at.strftime("%m/%d/%y")}")

    expect(page).to have_content("Top selling date for GameStop was 10/31/05")
    expect(page).to have_content("Top selling date for Target was 02/02/22")
  end
end
