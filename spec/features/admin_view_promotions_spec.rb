require "rails_helper"

feature "Admin view promotions" do
  scenario "must be signed in" do
    visit root_path
    click_on "Promoções"

    expect(current_path).to eq new_admin_session_path
  end

  scenario "successfully" do
    admin = create(:admin)
    promotion = create(:promotion, admin: admin)
    other_promotion = create(:promotion, name: "Cyber Monday",
                              description: "Promoção de Cyber Monday",
                              code: "CYBER15", discount_rate: 15,
                              admin: admin)

    login_as admin, scope: :admin
    visit root_path
    click_on "Promoções"

    expect(page).to have_content("Natal")
    expect(page).to have_content("Promoção de Natal")
    expect(page).to have_content("10,00%")
    expect(page).to have_content("Cyber Monday")
    expect(page).to have_content("Promoção de Cyber Monday")
    expect(page).to have_content("15,00%")
  end

  scenario "and view details" do
    admin = create(:admin)
    promotion = create(:promotion, admin: admin)
    other_promotion = create(:promotion, name: "Cyber Monday",
                              description: "Promoção de Cyber Monday",
                              code: "CYBER15", discount_rate: 15,
                              admin: admin)

    login_as admin, scope: :admin
    visit root_path
    click_on "Promoções"
    click_on "Natal"

    expect(page).to have_content("Natal")
    expect(page).to have_content("Promoção de Natal")
    expect(page).to have_content("10,00%")
    expect(page).to have_content("NATAL10")
    expect(page).to have_content("22/12/2033")
    expect(page).to have_content("100")
  end

  scenario "and no promotion are created" do
    admin = create(:admin)

    login_as admin, scope: :admin
    visit root_path
    click_on "Promoções"

    expect(page).to have_content("Nenhuma promoção cadastrada")
  end

  scenario "and return to home page" do
    admin = create(:admin)
    promotion = create(:promotion, admin: admin)

    login_as admin, scope: :admin
    visit root_path
    click_on "Promoções"
    click_on "Voltar"

    expect(current_path).to eq root_path
  end

  scenario "and return to promotions page" do
    admin = create(:admin)
    promotion = create(:promotion, name: "Natal", admin: admin)

    login_as admin, scope: :admin
    visit root_path
    click_on "Promoções"
    click_on "Natal"
    click_on "Voltar"

    expect(current_path).to eq promotions_path
  end
end
