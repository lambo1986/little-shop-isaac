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
    process_coupon_create_amount

    if @coupon.save
      redirect_to merchant_coupons_path(@merchant), notice: "Coupon was successfully created."
    else
      handle_coupon_create_errors
      redirect_to new_merchant_coupon_path(@merchant)
    end
  end

  def update
    @merchant_coupon = Coupon.find(params[:id])
    update_coupon_errors
  end

  private

  def coupon_params
    params.require(:coupon).permit(:name, :code)
  end
end

  def process_coupon_create_amount#updated form with drop menu to make sure one of the coupon types is always 0
    discount_type = params[:coupon][:discount_type]
  if discount_type == "Percent Off"
    @coupon.percent_off = params[:coupon][:amount].to_i
    @coupon.dollar_off = 0
  elsif discount_type == "Dollar Off"
    @coupon.dollar_off = params[:coupon][:amount].to_i
    @coupon.percent_off = 0
  end
end

  def handle_coupon_create_errors
  if @coupon.errors[:code].include?("has already been taken")
    flash[:alert] = "Unique coupon code required."
  elsif @coupon.errors[:base].include?("Only 5 active coupons can be used at a time.")
    flash[:alert] = "Only 5 active coupons can be used at a time."
  elsif @coupon.errors[:code].include?("can't be blank")
    flash[:alert] = "All fields are required."
  end
end

  def update_coupon_errors
  if params[:commit] == "deactivate"
    if @merchant_coupon.invoice_in_progress?
      redirect_to merchant_coupon_path, alert: "update failed do to pending invoice"
    else
      @merchant_coupon.update!(active: false)
      redirect_to merchant_coupon_path, notice: "update successful"
    end
  elsif params[:commit] == "activate"
    @merchant_coupon.update!(active: true)
    redirect_to merchant_coupon_path, notice: "update successful"
  end
end
