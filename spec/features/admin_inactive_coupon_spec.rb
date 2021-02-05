require "rails_helper"

feature "Admin inactivate coupon" do
  scenario "successfully" do
    promotion = Promotion.create!(name: "Natal", description: "", code: "NATAL10",
                                  coupon_quantity: 100, discount_rate: 10,
                                  expiration_date: "2021-10-10")
    promotion.coupons.create!(code: "NATAL10-0030")

    visit root_path
    click_on "Promoções"
    click_on promotion.name
    click_on "Inativar"

    expect(page).to have_content("NATAL10-0030 (Inativo)")
  end
end
