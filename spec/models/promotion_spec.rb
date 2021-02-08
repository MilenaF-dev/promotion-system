require "rails_helper"

describe Promotion do
  context "validation" do
    it "attributes cannot be blank" do
      admin = Admin.create!(email: "milena@email.com", password: "123456")
      promotion = Promotion.new(admin: admin)

      expect(promotion.valid?).to eq false
      expect(promotion.errors.count).to eq 5
    end

    it "description is optional" do
      admin = Admin.create!(email: "milena@email.com", password: "123456")
      promotion = Promotion.new(name: "Natal", description: "", code: "NAT",
                                coupon_quantity: 10, discount_rate: 10,
                                expiration_date: "2021-10-10", admin: admin)

      expect(promotion.valid?).to eq true
    end

    it "error messages are in portuguese" do
      promotion = Promotion.new

      promotion.valid?

      expect(promotion.errors[:name]).to include("não pode ficar em branco")
      expect(promotion.errors[:code]).to include("não pode ficar em branco")
      expect(promotion.errors[:discount_rate]).to include("não pode ficar em " \
                                                          "branco")
      expect(promotion.errors[:coupon_quantity]).to include("não pode ficar em" \
                                                            " branco")
      expect(promotion.errors[:expiration_date]).to include("não pode ficar em" \
                                                            " branco")
    end

    it "code must be uniq" do
      admin = Admin.create!(email: "milena@email.com", password: "123456")
      Promotion.create!(name: "Natal", description: "Promoção de Natal",
                        code: "NATAL10", discount_rate: 10,
                        coupon_quantity: 100, expiration_date: "22/12/2033", admin: admin)
      promotion = Promotion.new(code: "NATAL10")

      promotion.valid?

      expect(promotion.errors[:code]).to include("já está em uso")
    end

    it "coupon quantity must be less than 10000" do
      admin = Admin.create!(email: "milena@email.com", password: "123456")
      promotion = Promotion.new(name: "Natal", description: "Promoção de Natal",
                                code: "NATAL10", discount_rate: 10,
                                coupon_quantity: 10000, expiration_date: "22/12/2033", admin: admin)

      promotion.valid?

      expect(promotion.errors[:coupon_quantity]).to include("deve ser menor que 10000")
    end
  end

  context "#generate_coupons!" do
    it "generates coupons of coupons_quantity" do
      admin = Admin.create!(email: "milena@email.com", password: "123456")
      promotion = Promotion.create!(name: "Natal", description: "", code: "NATAL10",
                                    coupon_quantity: 100, discount_rate: 10,
                                    expiration_date: "2021-10-10", admin: admin)

      promotion.generate_coupons!

      expect(promotion.coupons.size).to eq(100)
      expect(promotion.coupons.pluck(:code)).to include("NATAL10-0001")
      expect(promotion.coupons.pluck(:code)).to include("NATAL10-0100")
      expect(promotion.coupons.pluck(:code)).not_to include("NATAL10-0000")
      expect(promotion.coupons.pluck(:code)).not_to include("NATAL10-0101")
    end

    it "do not generate if error" do
      admin = Admin.create!(email: "milena@email.com", password: "123456")
      promotion = Promotion.create!(name: "Natal", description: "", code: "NATAL10",
                                    coupon_quantity: 100, discount_rate: 10,
                                    expiration_date: "2021-10-10", admin: admin)
      promotion.coupons.create!(code: "NATAL10-0030")

      expect { promotion.generate_coupons! }.to raise_error(ActiveRecord::RecordNotUnique)

      expect(promotion.coupons.reload.size).to eq(1)
    end

    it "code and coupon quantity cannot be edited if coupons was generated" do
      admin = Admin.create!(email: "milena@email.com", password: "123456")
      promotion = Promotion.create!(name: "Natal", description: "", code: "NATAL10",
                                    coupon_quantity: 100, discount_rate: 10,
                                    expiration_date: "2021-10-10", admin: admin)
      promotion.generate_coupons!
      promotion.update(code: "NATAL15", coupon_quantity: 150)

      expect(promotion.errors[:code]).to include("não pode ser alterado")
      expect(promotion.errors[:coupon_quantity]).to include("não pode ser alterado")
    end
  end
end
