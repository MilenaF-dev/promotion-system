require "rails_helper"

feature "Admin register a valid category" do
  scenario "from index page" do
    visit root_path
    click_on "Categorias"

    expect(page).to have_link("Registrar uma categoria",
                              href: new_category_path)
  end

  scenario "successfully" do
    visit root_path
    click_on "Categorias"
    click_on "Registrar uma categoria"

    fill_in "Nome", with: "Eletrônicos"
    fill_in "Código", with: "CYBER15"
    click_on "Criar categoria"

    expect(current_path).to eq(category_path(Category.last))
    expect(page).to have_content("Eletrônicos")
    expect(page).to have_content("CYBER15")
  end

  scenario "and attributes cannot be blank" do
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

    visit root_path
    click_on "Categorias"
    click_on "Registrar uma categoria"
    fill_in "Código", with: "CYBER15"
    click_on "Criar categoria"

    expect(page).to have_content("já está em uso")
  end

  scenario "and return to promotions page" do
    visit root_path
    click_on "Categorias"
    click_on "Registrar uma categoria"

    expect(page).to have_link("Voltar",
                              href: categories_path)
  end
end
