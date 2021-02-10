require "rails_helper"

feature "Another admin approves promotion" do
  scenario "must not be the creator" do
    creator = Admin.create!(email: "milena@email.com", password: "123456")
    promotion = Promotion.create!(name: "Natal", description: "Promoção de Natal",
                                  code: "NATAL10", discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: "22/12/2033", admin: creator)
    approval_admin = Admin.create!(email: "milena.neeves@email.com", password: "654321")


    login_as creator, scope: :admin
    visit root_path
    click_on "Promoções"
    click_on promotion.name

    expect(page).not_to have_link("Aprovar promoção")
  end

  scenario "must be another admin" do
    creator = Admin.create!(email: "milena@email.com", password: "123456")
    promotion = Promotion.create!(name: "Natal", description: "Promoção de Natal",
                                  code: "NATAL10", discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: "22/12/2033", admin: creator)
    approval_admin = Admin.create!(email: "milena.neeves@email.com", password: "654321")


    login_as approval_admin, scope: :admin
    visit root_path
    click_on "Promoções"
    click_on promotion.name

    expect(page).to have_link("Aprovar promoção")
  end

  scenario "successfully" do
    creator = Admin.create!(email: "milena@email.com", password: "123456")
    promotion = Promotion.create!(name: "Natal", description: "Promoção de Natal",
                                  code: "NATAL10", discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: "22/12/2033", admin: creator)
    approval_admin = Admin.create!(email: "milena.neeves@email.com", password: "654321")


    login_as approval_admin, scope: :admin
    visit root_path
    click_on "Promoções"
    click_on promotion.name
    click_on "Aprovar promoção"

    promotion.reload
    expect(current_path).to eq(promotion_path(promotion))
    expect(promotion.approved?).to be_truthy
    expect(promotion.approver).to eq(approval_admin)
    expect(page).to have_content("Aprovada por: #{approval_admin.email}")
    expect(page).not_to have_link("Aprovar promoção")
  end
end