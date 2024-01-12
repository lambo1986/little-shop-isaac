class MerchantCouponsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @merchant_coupons = @merchant.coupons
  end

  def show
    @merchant_coupon = Coupon.find(params[:id])
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
      redirect_to "/merchants/#{@merchant.id}/coupons/new"
      flash[:alert] = "Error: all fields are required or must be unique." #needs work
    end
  end

  private

  def coupon_params
    params.require(:coupon).permit(:name, :code, :percent_off, :dollar_off)
  end
end
