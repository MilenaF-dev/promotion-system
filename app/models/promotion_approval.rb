class PromotionApproval < ApplicationRecord
  belongs_to :promotion
  belongs_to :admin

  validate :different_admin

  private

  def different_admin
    if promotion && promotion.admin == admin
      errors.add(:admin, "não pode ser o criador da promoção")
    end
  end
end
