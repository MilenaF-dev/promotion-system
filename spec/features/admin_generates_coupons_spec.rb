require "rails_helper"

feature "Admin generates coupons" do
  scenario "must be signed in" do
    visit root_path
    click_on "Promoções"

    expect(current_path).to eq new_admin_session_path
  end

  scenario "successfully" do
    admin = Admin.create!(email: "milena@email.com", password: "123456")
    promotion = Promotion.create!(name: "Natal", description: "Promoção de Natal",
                                  code: "NATAL10", discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: "22/12/2033", admin: admin)

    login_as admin, scope: :admin
    visit root_path
    click_on "Promoções"
    click_on promotion.name
    click_on "Gerar cupons"

    expect(current_path).to eq(promotion_path(promotion))
    expect(page).to have_content("Cupons gerados com sucesso")
    expect(page).to have_content("NATAL10-0001")
    expect(page).to have_content("NATAL10-0002")
    expect(page).to have_content("NATAL10-0100")
    expect(page).not_to have_content("NATAL10-0101")
  end

  scenario "button disappear if coupons was generated" do
    admin = Admin.create!(email: "milena@email.com", password: "123456")
    promotion = Promotion.create!(name: "Natal", description: "", code: "NATAL10",
                                  coupon_quantity: 100, discount_rate: 10,
                                  expiration_date: "2021-10-10", admin: admin)

    login_as admin, scope: :admin
    visit root_path
    click_on "Promoções"
    click_on promotion.name
    click_on "Gerar cupons"

    expect(page).not_to have_link("Gerar cupons")
  end
end
