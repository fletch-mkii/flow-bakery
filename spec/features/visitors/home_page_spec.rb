# Feature: Home page
#   As a visitor
#   I want to visit a home page
#   So I can learn more about the website
feature 'Home page' do
  feature 'For a Visitor' do
    # Scenario: Visit the home page
    #   Given I am a visitor
    #   When I visit the home page
    #   Then I see "Welcome"
    scenario 'visit the home page' do
      visit root_path
      expect(page).to have_content 'Welcome'
    end
  end

  feature 'For a Bakery Owner' do
    # Scenario: Visit the home page
    #   Given I am a bakery owner
    #   When I visit the home page
    #   I see a list of cookies for sale
    scenario 'view list of cookies for sale' do
      user = create_and_signin
      cookie_without_fillings_1 = FactoryGirl.create(:cookie, storage: user, fillings: "")
      cookie_without_fillings_2 = FactoryGirl.create(:cookie, storage: user, fillings: nil)
      cookie_with_fillings = FactoryGirl.create(:cookie, storage: user, fillings: "broccoli")

      visit root_path

      expect(page).to have_content '2 Cookies with no filling'
      expect(page).to have_content '1 Cookie with broccoli'
    end
  end
end
