class PromotionsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @promotions = Promotion.all
  end

  def show
    set_promotions
  end

  def new
    @promotion = Promotion.new
    @payment_methods = PaymentMethod.all
  end

  def create
    @promotion = Promotion.new(promotion_params)
    @promotion.admin = current_admin

    if @promotion.save
      redirect_to promotion_path(id: @promotion.id)
    else
      render :new
    end
  end

  def edit
    set_promotions
  end

  def update
    set_promotions

    if @promotion.update(promotion_params)
      redirect_to promotion_path(id: @promotion.id)
    else
      render :edit
    end
  end

  def destroy
    set_promotions
    @promotion.destroy

    flash[:notice] = "Promoção apagada com sucesso!"
    redirect_to promotions_path
  end

  def generate_coupons
    set_promotions
    @promotion.generate_coupons!
    redirect_to @promotion, notice: t(".success")
  end

  def approve
    set_promotions
    @promotion.approve!(current_admin)
    redirect_to @promotion
  end

  private

  def set_promotions
    @promotion = Promotion.find(params[:id])
  end

  def promotion_params
    params.require(:promotion).permit(:name, :description, :discount_rate, :code, :coupon_quantity, :expiration_date)
  end
end
