class PromotionApproval < ApplicationRecord
  belongs_to :promotion
  belongs_to :admin

  validate :different_admin

  private

  def different_admin
    return errors.add(:admin, "não pode ser o criador da promoção") if promotion && promotion.admin == admin
  end
end
