require "rails_helper"

describe "Coupon management" do
  context "GET coupon" do
    it "should render coupon informations" do
      admin = Admin.create!(email: "milena@email.com", password: "123456")
      promotion = Promotion.create!(name: "Natal", description: "", code: "NATAL10",
                                    coupon_quantity: 1, discount_rate: 10,
                                    expiration_date: "10/10/2021", admin: admin)
      promotion.generate_coupons!
      coupon = Coupon.last

      get "/api/v1/coupons/#{coupon.code}"

      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(200)
      expect(json_response[:status]).to eq("active")
      expect(json_response[:code]).to eq(coupon.code)
      expect(json_response[:promotion][:discount_rate].to_f).to eq(promotion.discount_rate.to_f)
    end

    it "should return 404 if coupon code does not exist" do
      get "/api/v1/coupons/BLACKFRIDAY"

      expect(response).to have_http_status(:not_found)
    end
  end
end
