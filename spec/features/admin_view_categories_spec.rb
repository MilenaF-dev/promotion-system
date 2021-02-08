require "rails_helper"

feature "Admin view categories" do
  scenario "must be signed in" do
    visit root_path
    click_on "Categorias"

    expect(current_path).to eq new_admin_session_path
  end

  scenario "successfully" do
    Category.create!(name: "Eletrônicos", code: "CYBER15")
    Category.create!(name: "Livros", code: "BOOK20")
    admin = Admin.create!(email: "milena@email.com", password: "123456")

    login_as admin, scope: :admin
    visit root_path
    click_on "Categorias"

    expect(page).to have_content("Eletrônicos")
    expect(page).to have_content("Livros")
  end

  scenario "and view details" do
    Category.create!(name: "Eletrônicos", code: "CYBER15")
    Category.create!(name: "Livros", code: "BOOK20")
    admin = Admin.create!(email: "milena@email.com", password: "123456")

    login_as admin, scope: :admin
    visit root_path
    click_on "Categorias"
    click_on "Livros"

    expect(page).to have_content("Livros")
    expect(page).to have_content("BOOK20")
  end

  scenario "and no category are created" do
    admin = Admin.create!(email: "milena@email.com", password: "123456")

    login_as admin, scope: :admin
    visit root_path
    click_on "Categorias"

    expect(page).to have_content("Nenhuma categoria cadastrada")
  end

  scenario "and return to home page" do
    Category.create!(name: "Eletrônicos", code: "CYBER15")
    admin = Admin.create!(email: "milena@email.com", password: "123456")

    login_as admin, scope: :admin
    visit root_path
    click_on "Categorias"
    click_on "Voltar"

    expect(current_path).to eq root_path
  end

  scenario "and return to promotions page" do
    Category.create!(name: "Eletrônicos", code: "CYBER15")
    admin = Admin.create!(email: "milena@email.com", password: "123456")

    login_as admin, scope: :admin
    visit root_path
    click_on "Categorias"
    click_on "Eletrônicos"
    click_on "Voltar"

    expect(current_path).to eq categories_path
  end
end
