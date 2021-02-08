require "rails_helper"

feature "Admin edit a existent promotion" do
  scenario "must be signed in" do
    visit root_path
    click_on "Promoções"

    expect(current_path).to eq new_admin_session_path
  end

  scenario "from index page" do
    admin = Admin.create!(email: "milena@email.com", password: "123456")
    Promotion.create!(name: "Natal", description: "Promoção de Natal",
                      code: "NATAL10", discount_rate: 10, coupon_quantity: 100,
                      expiration_date: "22/12/2033", admin: admin)

    login_as admin, scope: :admin
    visit root_path
    click_on "Promoções"
    click_on "Natal"

    expect(page).to have_link("Editar",
                              href: edit_promotion_path(Promotion.last))
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
    click_on "Editar"

    fill_in "Nome", with: "Cyber Monday"
    fill_in "Descrição", with: "Promoção de Cyber Monday"
    fill_in "Código", with: "CYBER15"
    fill_in "Desconto", with: "15"
    fill_in "Quantidade de cupons", with: "90"
    fill_in "Data de término", with: "15/10/2023"
    click_on "Atualizar promoção"

    expect(current_path).to eq(promotion_path(Promotion.last))
    expect(page).to have_content("Cyber Monday")
    expect(page).to have_content("Promoção de Cyber Monday")
    expect(page).to have_content("15,00%")
    expect(page).to have_content("CYBER15")
    expect(page).to have_content("15/10/2023")
    expect(page).to have_content("90")
    expect(page).to have_link("Voltar")
  end

  scenario "and attributes cannot be blank" do
    admin = Admin.create!(email: "milena@email.com", password: "123456")
    Promotion.create!(name: "Natal", description: "Promoção de Natal",
                      code: "NATAL10", discount_rate: 10, coupon_quantity: 100,
                      expiration_date: "22/12/2033", admin: admin)

    login_as admin, scope: :admin
    visit root_path
    click_on "Promoções"
    click_on "Natal"
    click_on "Editar"

    fill_in "Nome", with: ""
    fill_in "Descrição", with: ""
    fill_in "Código", with: ""
    fill_in "Desconto", with: ""
    fill_in "Quantidade de cupons", with: ""
    fill_in "Data de término", with: ""
    click_on "Atualizar promoção"

    expect(page).to have_content("Não foi possível editar a promoção")
    expect(page).to have_content("Nome não pode ficar em branco")
    expect(page).to have_content("Código não pode ficar em branco")
    expect(page).to have_content("Desconto não pode ficar em branco")
    expect(page).to have_content("Quantidade de cupons não pode ficar em branco")
    expect(page).to have_content("Data de término não pode ficar em branco")
  end

  scenario "and code must be unique" do
    admin = Admin.create!(email: "milena@email.com", password: "123456")
    Promotion.create!(name: "Natal", description: "Promoção de Natal",
                      code: "NATAL10", discount_rate: 10, coupon_quantity: 100,
                      expiration_date: "22/12/2033", admin: admin)
    Promotion.create!(name: "Cyber Monday", coupon_quantity: 100,
                      description: "Promoção de Cyber Monday",
                      code: "CYBER15", discount_rate: 15,
                      expiration_date: "22/12/2033", admin: admin)

    login_as admin, scope: :admin
    visit root_path
    click_on "Promoções"
    click_on "Natal"
    click_on "Editar"

    fill_in "Código", with: "CYBER15"
    click_on "Atualizar promoção"

    expect(page).to have_content("Código já está em uso")
  end

  scenario "and return to promotion page" do
    admin = Admin.create!(email: "milena@email.com", password: "123456")
    Promotion.create!(name: "Natal", description: "Promoção de Natal",
                      code: "NATAL10", discount_rate: 10, coupon_quantity: 100,
                      expiration_date: "22/12/2033", admin: admin)

    login_as admin, scope: :admin
    visit root_path
    click_on "Promoções"
    click_on "Natal"
    click_on "Editar"
    click_on "Voltar"

    expect(current_path).to eq promotion_path(Promotion.last)
  end
end
