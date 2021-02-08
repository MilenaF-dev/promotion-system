require "rails_helper"

feature "Admin register a valid category" do
  scenario "must be signed in" do
    visit root_path
    click_on "Categorias"

    expect(current_path).to eq new_admin_session_path
  end

  scenario "from index page" do
    admin = Admin.create!(email: "milena@email.com", password: "123456")

    login_as admin, scope: :admin
    visit root_path
    click_on "Categorias"

    expect(page).to have_link("Registrar uma categoria",
                              href: new_category_path)
  end

  scenario "successfully" do
    admin = Admin.create!(email: "milena@email.com", password: "123456")

    login_as admin, scope: :admin
    visit root_path
    click_on "Categorias"
    click_on "Registrar uma categoria"

    fill_in "Nome", with: "Eletrônicos"
    fill_in "Código", with: "CYBER15"
    click_on "Criar categoria"

    expect(current_path).to eq(category_path(Category.last))
    expect(page).to have_content("Eletrônicos")
    expect(page).to have_content("CYBER15")
    expect(page).to have_link("Voltar")
  end

  scenario "and attributes cannot be blank" do
    admin = Admin.create!(email: "milena@email.com", password: "123456")

    login_as admin, scope: :admin
    visit root_path
    click_on "Categorias"
    click_on "Registrar uma categoria"

    fill_in "Nome", with: ""
    fill_in "Código", with: ""
    click_on "Criar categoria"

    expect(Category.count).to eq 0
    expect(page).to have_content("Não foi possível criar a categoria")
    expect(page).to have_content("Nome não pode ficar em branco")
    expect(page).to have_content("Código não pode ficar em branco")
  end

  scenario "and code must be unique" do
    Category.create!(name: "Eletrônicos", code: "CYBER15")
    admin = Admin.create!(email: "milena@email.com", password: "123456")

    login_as admin, scope: :admin
    visit root_path
    click_on "Categorias"
    click_on "Registrar uma categoria"
    fill_in "Código", with: "CYBER15"
    click_on "Criar categoria"

    expect(page).to have_content("já está em uso")
  end
end
