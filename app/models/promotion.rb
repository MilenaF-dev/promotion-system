class Promotion < ApplicationRecord
  has_many :coupons, dependent: :destroy
  belongs_to :admin

  validates :name, :code, :discount_rate, :expiration_date, :coupon_quantity, presence: true
  validates :name, :code, uniqueness: true
  validates :coupon_quantity, numericality: { less_than: 10000 }, allow_nil: true
  validate :code_cannot_be_edited_if_coupons_present, :coupon_quantity_cannot_be_edited_if_coupons_present, on: :update

  def generate_coupons!
    array_coupons = (1..coupon_quantity).map do |number|
      {
        code: "#{code}-#{"%04d" % number}",
        created_at: Time.current,
        updated_at: Time.current,
      }
    end
    Coupon.transaction do
      coupons.insert_all!(array_coupons)
    end
  end

  private

  def code_cannot_be_edited_if_coupons_present
    if code_changed? && coupons.any?
      errors.add(:code, "não pode ser alterado")
    end
  end

  def coupon_quantity_cannot_be_edited_if_coupons_present
    if coupon_quantity_changed? && coupons.any?
      errors.add(:coupon_quantity, "não pode ser alterado")
    end
  end
end
