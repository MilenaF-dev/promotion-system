require "rails_helper"

feature "Admin view categories" do
  scenario "successfully" do
    Category.create!(name: "Eletrônicos", code: "CYBER15")
    Category.create!(name: "Livros", code: "BOOK20")

    visit root_path
    click_on "Categorias"

    expect(page).to have_content("Eletrônicos")
    expect(page).to have_content("Livros")
  end

  scenario "and view details" do
    Category.create!(name: "Eletrônicos", code: "CYBER15")
    Category.create!(name: "Livros", code: "BOOK20")

    visit root_path
    click_on "Categorias"
    click_on "Livros"

    expect(page).to have_content("Livros")
    expect(page).to have_content("BOOK20")
  end

  scenario "and no category are created" do
    visit root_path
    click_on "Categorias"

    expect(page).to have_content("Nenhuma categoria cadastrada")
  end

  scenario "and return to home page" do
    Category.create!(name: "Eletrônicos", code: "CYBER15")

    visit root_path
    click_on "Categorias"
    click_on "Voltar"

    expect(current_path).to eq root_path
  end

  scenario "and return to promotions page" do
    Category.create!(name: "Eletrônicos", code: "CYBER15")

    visit root_path
    click_on "Categorias"
    click_on "Eletrônicos"
    click_on "Voltar"

    expect(current_path).to eq categories_path
  end
end
