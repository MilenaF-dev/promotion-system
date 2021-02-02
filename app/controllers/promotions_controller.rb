class PromotionsController < ApplicationController
  def index
    @promotions = Promotion.all
  end

  def show
    set_promotions
  end

  def new
    @promotion = Promotion.new
  end

  def create
    @promotion = Promotion.new(promotion_params)

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

  private

  def set_promotions
    @promotion = Promotion.find(params[:id])
  end

  def promotion_params
    params.require(:promotion).permit(:name, :description, :discount_rate, :code, :coupon_quantity, :expiration_date)
  end
end
