FactoryBot.define do
  factory :promotion do
    name { "Natal" }
    description { "Promoção de Natal" }
    code { "NATAL10" } 
    discount_rate { 10 } 
    coupon_quantity { 100 }
    expiration_date { "22/12/2033" } 

    admin
  end
end
