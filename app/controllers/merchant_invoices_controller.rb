class MerchantInvoicesController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @merchant_invoices = @merchant.merchant_invoices
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @invoice = Invoice.find(params[:id]) #@invoice.items for items on invoice and @invoice.invoice_items[0].unit_price for invoice items
    @customer = Customer.find(@invoice.customer_id)
    @coupon = Coupon.find(@invoice.coupon_id) if @invoice.coupon_id.present?# US-7 not sure why I need this
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @invoice = Invoice.find(params[:id])

    invoice_item = InvoiceItem.find(params[:invoice_item_id])
    invoice_item.update(status: (params[:status]))

    redirect_to ("/merchants/#{@merchant.id}/invoices/#{@invoice.id}")
  end
end
