require "rails_helper"

feature "Admin activate coupon" do
  scenario "must be signed in" do
    visit root_path
    click_on "Promoções"

    expect(current_path).to eq new_admin_session_path
  end

  scenario "successfully" do
    admin = Admin.create!(email: "milena@email.com", password: "123456")
    promotion = Promotion.create!(name: "Natal", description: "", code: "NATAL10",
                                  coupon_quantity: 100, discount_rate: 10,
                                  expiration_date: "2021-10-10", admin: admin)
    coupon = Coupon.create!(code: "NATAL10-0030", promotion: promotion, status: :inactive)

    login_as admin, scope: :admin
    visit root_path
    click_on "Promoções"
    click_on promotion.name
    click_on "Ativar"

    coupon.reload
    expect(page).to have_content("NATAL10-0030 (Ativo)")
    expect(coupon).to be_active
  end

  scenario "does not view button" do
    admin = Admin.create!(email: "milena@email.com", password: "123456")
    promotion = Promotion.create!(name: "Natal", description: "", code: "NATAL10",
                                  coupon_quantity: 100, discount_rate: 10,
                                  expiration_date: "2021-10-10", admin: admin)
    inactive_coupon = Coupon.create!(code: "NATAL10-0030", promotion: promotion, status: :inactive)
    active_coupon = Coupon.create!(code: "NATAL10-0031", promotion: promotion, status: :active)

    login_as admin, scope: :admin
    visit root_path
    click_on "Promoções"
    click_on promotion.name

    expect(page).to have_content("NATAL10-0030 (Inativo)")
    expect(page).to have_content("NATAL10-0031 (Ativo)")

    within("div#coupon-#{active_coupon.id}") do
      expect(page).not_to have_link("Ativar")
    end

    within("div#coupon-#{inactive_coupon.id}") do
      expect(page).to have_link("Ativar")
    end
  end

  scenario "active request protected", type: :request do
    admin = Admin.create!(email: "milena@email.com", password: "123456")
    promotion = Promotion.create!(name: "Natal", description: "", code: "NATAL10",
                                  coupon_quantity: 100, discount_rate: 10,
                                  expiration_date: "2021-10-10", admin: admin)
    active_coupon = Coupon.create!(code: "NATAL10-0030", promotion: promotion, status: :active)

    post activate_coupon_path(active_coupon)

    expect(response.status).to eq(404)
  end
end
