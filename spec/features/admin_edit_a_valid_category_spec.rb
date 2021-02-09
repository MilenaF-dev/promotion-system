require "rails_helper"

feature "Admin edit a existent promotion" do
  scenario "must be signed in" do
    category = Category.create!(name: "Eletrônicos", code: "CYBER15")

    visit category_path(category)
  
    expect(current_path).to eq new_admin_session_path
  end

  scenario "from index page" do
    category = Category.create!(name: "Eletrônicos", code: "CYBER15")
    admin = Admin.create!(email: "milena@email.com", password: "123456")

    login_as admin, scope: :admin
    visit root_path
    click_on "Categorias"
    click_on category.name

    expect(page).to have_link("Editar",
                              href: edit_category_path(category))
  end

  scenario "successfully" do
    category = Category.create!(name: "Eletrônicos", code: "CYBER15")
    admin = Admin.create!(email: "milena@email.com", password: "123456")

    login_as admin, scope: :admin
    visit root_path
    click_on "Categorias"
    click_on category.name
    click_on "Editar"

    fill_in "Nome", with: "Livros"
    fill_in "Código", with: "BOOK15"
    click_on "Atualizar categoria"

    expect(current_path).to eq(category_path(category))
    expect(page).to have_content("Livros")
    expect(page).to have_content("BOOK15")
    expect(page).to have_link("Voltar")
  end

  scenario "and attributes cannot be blank" do
    category = Category.create!(name: "Eletrônicos", code: "CYBER15")
    admin = Admin.create!(email: "milena@email.com", password: "123456")

    login_as admin, scope: :admin
    visit root_path
    click_on "Categorias"
    click_on category.name
    click_on "Editar"

    fill_in "Nome", with: ""
    fill_in "Código", with: ""
    click_on "Atualizar categoria"

    expect(page).to have_content("Não foi possível editar a categoria")
    expect(page).to have_content("Nome não pode ficar em branco")
    expect(page).to have_content("Código não pode ficar em branco")
  end

  scenario "and code must be unique" do
    category = Category.create!(name: "Eletrônicos", code: "CYBER15")
    Category.create!(name: "Livros", code: "BOOK15")
    admin = Admin.create!(email: "milena@email.com", password: "123456")

    login_as admin, scope: :admin
    visit root_path
    click_on "Categorias"
    click_on category.name
    click_on "Editar"

    fill_in "Código", with: "BOOK15"
    click_on "Atualizar categoria"

    expect(page).to have_content("Código já está em uso")
  end

  scenario "and return to promotion page" do
    category = Category.create!(name: "Eletrônicos", code: "CYBER15")
    admin = Admin.create!(email: "milena@email.com", password: "123456")

    login_as admin, scope: :admin
    visit root_path
    click_on "Categorias"
    click_on category.name
    click_on "Editar"
    click_on "Voltar"

    expect(current_path).to eq(category_path(category))
  end
end
