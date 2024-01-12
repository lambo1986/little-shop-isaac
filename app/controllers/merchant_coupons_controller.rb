class MerchantCouponsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @merchant_coupons = @merchant.coupons
  end

  def show
    @merchant_coupon = Coupon.find(params[:id])
    @merchant = Merchant.find(@merchant_coupon.merchant_id)
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @coupon = Coupon.new
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @coupon = @merchant.coupons.new(coupon_params)
    if @coupon.save
      redirect_to "/merchants/#{@merchant.id}/coupons", notice: "Coupon was successfully created."
    else
      if @coupon.errors[:code].include?("has already been taken")
        flash[:alert] = "Unique coupon code required."
      elsif @coupon.errors.messages.any? { |field, messages| messages.include?("can't be blank") }
        flash[:alert] = "All fields are required."
      elsif @coupon.errors.messages.any? { |field, messages| messages.include?("Only 5 active coupons can be used at a time.") }
        flash[:alert] = "Only 5 active coupons can be used at a time."
      end
      redirect_to "/merchants/#{@merchant.id}/coupons/new"
    end
  end

  def update
    @merchant_coupon = Coupon.find(params[:id])
    if params[:commit] == "deactivate"
      if @merchant_coupon.invoice_in_progress?
        redirect_to "/merchants/#{@merchant_coupon.merchant_id}/coupons/#{@merchant_coupon.id}", alert: "update failed do to pending invoice"
      else
        @merchant_coupon.update!(active: false)
        redirect_to "/merchants/#{@merchant_coupon.merchant_id}/coupons/#{@merchant_coupon.id}", notice: "update successful"
      end
    end
  end

  private

  def coupon_params
    params.require(:coupon).permit(:name, :code, :percent_off, :dollar_off)
  end
end
