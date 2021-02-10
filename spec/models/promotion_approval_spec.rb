require 'rails_helper'

RSpec.describe PromotionApproval, type: :model do
  describe "#valid?" do
    describe "different admin" do
      it "is different" do
        creator = Admin.create!(email: "milena@email.com", password: "123456")
        promotion = Promotion.create!(name: "Natal", description: "Promoção de Natal",
                                      code: "NATAL10", discount_rate: 10, coupon_quantity: 100,
                                      expiration_date: "22/12/2033", admin: creator)
        approval_admin = Admin.create!(email: "milena.neeves@email.com", password: "654321")

        approval = PromotionApproval.new(promotion: promotion, admin: approval_admin)

        result = approval.valid?

        expect(result).to eq(true)
      end

      it "is the same" do
        creator = Admin.create!(email: "milena@email.com", password: "123456")
        promotion = Promotion.create!(name: "Natal", description: "Promoção de Natal",
                                      code: "NATAL10", discount_rate: 10, coupon_quantity: 100,
                                      expiration_date: "22/12/2033", admin: creator)

        approval = PromotionApproval.new(promotion: promotion, admin: creator)

        result = approval.valid?

        expect(result).to eq(false)
      end

      it "has no promotion or user" do
        approval = PromotionApproval.new()
        
        result = approval.valid?

        expect(result).to eq(false)
      end
    end
  end
end
