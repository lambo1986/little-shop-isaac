require 'rails_helper'

RSpec.describe "admin dashboard" do
  before(:each) do
    @merch_1 = Merchant.create!(name: "Walmart", status: :enabled)
    @merch_2 = Merchant.create!(name: "Target", status: :enabled)

    @item_1 = @merch_1.items.create!(name: "Apple", description: "red apple", unit_price:1)
    @item_2 = @merch_1.items.create!(name: "Orange", description: "orange orange", unit_price:1)

    @item_3 = @merch_2.items.create!(name: "Blood Orange", description: "blood orange", unit_price:1)
    @item_4 = @merch_2.items.create!(name: "Grape", description: "Red Grape", unit_price:1)

    @cust_1 = Customer.create!(first_name: "Larry", last_name: "Johnson")
    @cust_2 = Customer.create!(first_name: "Pam", last_name: "Nelson")
    @cust_3 = Customer.create!(first_name: "Logan", last_name: "Finnegan")
    @cust_4 = Customer.create!(first_name: "Nate", last_name: "Lambertson")
    @cust_5 = Customer.create!(first_name: "Martin", last_name: "chavez")
    @cust_6 = Customer.create!(first_name: "Isaac", last_name: "Mitchell")

    @inv_1 = @cust_1.invoices.create!(status: :completed, created_at:Time.new(2021, 10, 31) )
    @inv_2 = @cust_2.invoices.create!(status: :completed)
    @inv_3 = @cust_3.invoices.create!(status: :completed)
    @inv_4 = @cust_4.invoices.create!(status: :completed)
    @inv_5 = @cust_5.invoices.create!(status: :in_progress,created_at:Time.new(2024, 02, 1))
    @inv_6 = @cust_6.invoices.create!(status: :cancelled, created_at:Time.new(2021, 10, 31))

    @tran_1 = @inv_1.transactions.create!(credit_card_number: "2222 2222 2222 2222", credit_card_expiration_date: "01/2021", result: :success )
    @tran_2 = @inv_2.transactions.create!(credit_card_number: "2222 2222 2222 2222", credit_card_expiration_date: "02/2022", result: :success )
    @tran_3 = @inv_3.transactions.create!(credit_card_number: "2222 2222 2222 2222", credit_card_expiration_date: "03/2023", result: :success )
    @tran_4 = @inv_4.transactions.create!(credit_card_number: "2222 2222 2222 2222", credit_card_expiration_date: "04/2024", result: :success )
    @tran_5 = @inv_5.transactions.create!(credit_card_number: "2222 2222 2222 2222", credit_card_expiration_date: "05/2025", result: :success )
    @tran_6 = @inv_6.transactions.create!(credit_card_number: "2222 2222 2222 2222", credit_card_expiration_date: "06/2026", result: :failed )

    @ii_1 = InvoiceItem.create!(invoice: @inv_1, item: @item_1, quantity: 10, unit_price: 1, status: :shipped )
    @ii_2 = InvoiceItem.create!(invoice: @inv_1, item: @item_2, quantity: 10, unit_price: 1, status: :shipped)
    @ii_3 = InvoiceItem.create!(invoice: @inv_1, item: @item_3, quantity: 10, unit_price: 1, status: :shipped )
    @ii_4 = InvoiceItem.create!(invoice: @inv_2, item: @item_1, quantity: 10, unit_price: 1, status: :shipped )
    @ii_5 = InvoiceItem.create!(invoice: @inv_2, item: @item_2, quantity: 10, unit_price: 1, status: :shipped)
    @ii_6 = InvoiceItem.create!(invoice: @inv_2, item: @item_3, quantity: 10, unit_price: 1, status: :shipped )
    @ii_7 = InvoiceItem.create!(invoice: @inv_3, item: @item_1, quantity: 10, unit_price: 1, status: :shipped )
    @ii_8 = InvoiceItem.create!(invoice: @inv_3, item: @item_2, quantity: 10, unit_price: 1, status: :shipped)
    @ii_9 = InvoiceItem.create!(invoice: @inv_3, item: @item_3, quantity: 10, unit_price: 1, status: :shipped )
    @ii_10 = InvoiceItem.create!(invoice: @inv_4, item: @item_1, quantity: 10, unit_price: 1, status: :shipped )
    @ii_11 = InvoiceItem.create!(invoice: @inv_4, item: @item_2, quantity: 10, unit_price: 1, status: :shipped)
    @ii_12 = InvoiceItem.create!(invoice: @inv_4, item: @item_3, quantity: 10, unit_price: 1, status: :shipped )
    @ii_13 = InvoiceItem.create!(invoice: @inv_5, item: @item_1, quantity: 10, unit_price: 1, status: :shipped )
    @ii_14 = InvoiceItem.create!(invoice: @inv_5, item: @item_2, quantity: 10, unit_price: 1, status: :shipped)
    @ii_15 = InvoiceItem.create!(invoice: @inv_5, item: @item_3, quantity: 10, unit_price: 1, status: :pending )
    @ii_16 = InvoiceItem.create!(invoice: @inv_6, item: @item_1, quantity: 10, unit_price: 1, status: :shipped )
    @ii_17 = InvoiceItem.create!(invoice: @inv_6, item: @item_2, quantity: 10, unit_price: 1, status: :shipped)
    @ii_18= InvoiceItem.create!(invoice: @inv_6, item: @item_3, quantity: 10, unit_price: 1, status: :shipped )
    @ii_19 = InvoiceItem.create!(invoice: @inv_6, item: @item_4, quantity: 10, unit_price: 1, status: :pending )
  end

  describe 'it exists' do
    it 'has a header' do

      visit admin_root_path

      expect(page).to have_content("Admin Dashboard")
    end

    it "has links to admin merchants and routes a user" do

      visit admin_root_path

      expect(page).to have_link("Admin Merchants")

      click_link ("Admin Merchants")

      expect(current_path).to eq(admin_merchants_path)
    end

    it "has links to admin invoices and routes a user" do

      visit admin_root_path

      expect(page).to have_link("Admin Invoices")

      click_link ("Admin Invoices")

      expect(current_path).to eq(admin_invoices_path)
    end

    # 21. Admin Dashboard Statistics - Top Customers
    it "shows the top 5 customers and the amount of their transactions" do

      visit admin_root_path

      within '.top-five' do
        expect(page).to have_content("#{@cust_1.first_name} #{@cust_1.last_name} - 1 purchases")
        expect(page).to have_content("#{@cust_2.first_name} #{@cust_2.last_name} - 1 purchases")
        expect(page).to have_content("#{@cust_3.first_name} #{@cust_3.last_name} - 1 purchases")
        expect(page).to have_content("#{@cust_4.first_name} #{@cust_4.last_name} - 1 purchases")
        expect(page).to have_content("#{@cust_5.first_name} #{@cust_5.last_name} - 1 purchases")
        expect(page).to_not have_content("#{@cust_6.first_name} #{@cust_6.last_name} - 1 purchases")
      end
    end

    it "see a section for Incomplete Invoices that have not yet been shipped" do

      visit admin_root_path

      expect(page).to have_content("Invoice#-#{@ii_15.invoice_id}")
      expect(page).to_not have_content(@ii_2.invoice_id)
      expect(page).to have_link(@ii_15.invoice_id.to_s)

      click_link @ii_15.invoice_id.to_s

      expect(current_path).to eq(admin_invoice_path(@ii_15.invoice))
    end

    it "list the date in order" do
      visit admin_root_path

      expect("Invoice#-#{@ii_19.invoice_id}").to appear_before("Invoice#-#{@ii_15.invoice_id}")
    end
  end
end
