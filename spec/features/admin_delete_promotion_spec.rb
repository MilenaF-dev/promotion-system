require "rails_helper"

feature "Admin delete a existent promotion" do
  scenario "from index page" do
    admin = Admin.create!(email: "milena@email.com", password: "123456")
    Promotion.create!(name: "Natal", description: "Promoção de Natal",
                      code: "NATAL10", discount_rate: 10, coupon_quantity: 100,
                      expiration_date: "22/12/2033", admin: admin)

    login_as admin, scope: :admin
    visit root_path
    click_on "Promoções"
    click_on "Natal"

    expect(page).to have_selector("a[href='#{promotion_path(Promotion.last)}'][data-method='delete']", text: "Apagar")
  end

  scenario "successfully" do
    admin = Admin.create!(email: "milena@email.com", password: "123456")
    Promotion.create!(name: "Natal", description: "Promoção de Natal",
                      code: "NATAL10", discount_rate: 10, coupon_quantity: 100,
                      expiration_date: "22/12/2033", admin: admin)

    login_as admin, scope: :admin
    visit root_path
    click_on "Promoções"
    click_on "Natal"
    click_on "Apagar"

    expect(page).to have_content("Promoção apagada com sucesso!")
    expect(page).to_not have_content("Natal")
  end
end
