class MerchantCouponsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @merchant_coupons = @merchant.coupons
  end

  def show
    @merchant_coupon = Coupon.find(params[:id])
  end
end
