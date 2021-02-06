require "rails_helper"

feature "Admin inactivate coupon" do
  scenario "successfully" do
    promotion = Promotion.create!(name: "Natal", description: "", code: "NATAL10",
                                  coupon_quantity: 100, discount_rate: 10,
                                  expiration_date: "2021-10-10")
    coupon = Coupon.create!(code: "NATAL10-0030", promotion: promotion)

    visit root_path
    click_on "Promoções"
    click_on promotion.name
    click_on "Inativar"

    coupon.reload
    expect(page).to have_content("NATAL10-0030 (Inativo)")
    expect(coupon).to be_inactive
  end

  scenario "does not view button" do
    promotion = Promotion.create!(name: "Natal", description: "", code: "NATAL10",
                                  coupon_quantity: 100, discount_rate: 10,
                                  expiration_date: "2021-10-10")
    inactive_coupon = Coupon.create!(code: "NATAL10-0030", promotion: promotion, status: :inactive)
    active_coupon = Coupon.create!(code: "NATAL10-0031", promotion: promotion, status: :active)

    visit root_path
    click_on "Promoções"
    click_on promotion.name

    expect(page).to have_content("NATAL10-0030 (Inativo)")
    expect(page).to have_content("NATAL10-0031 (Ativo)")

    within("div#coupon-#{active_coupon.id}") do
      expect(page).to have_link("Inativar")
    end

    within("div#coupon-#{inactive_coupon.id}") do
      expect(page).not_to have_link("Inativar")
    end
  end

  scenario "inactive request can be made multiple times", type: :request do
    promotion = Promotion.create!(name: "Natal", description: "", code: "NATAL10",
                                  coupon_quantity: 100, discount_rate: 10,
                                  expiration_date: "2021-10-10")
    inactive_coupon = Coupon.create!(code: "NATAL10-0030", promotion: promotion, status: :inactive)

    expect { post inactivate_coupon_path(inactive_coupon) }.not_to change { inactive_coupon.reload.updated_at }
  end
end
