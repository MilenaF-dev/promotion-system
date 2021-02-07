class CouponsController < ApplicationController
  def inactivate
    @coupon = Coupon.find(params[:id])
    return head :not_found if @coupon.inactive?
    @coupon.inactive!

    redirect_to @coupon.promotion
  end

  def activate
    @coupon = Coupon.find(params[:id])
    return head :not_found if @coupon.active?
    @coupon.active!

    redirect_to @coupon.promotion
  end
end
