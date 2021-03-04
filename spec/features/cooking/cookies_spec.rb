feature 'Cooking cookies' do
  scenario 'Cooking zero cookies' do
    user = create_and_signin
    oven = user.ovens.first

    visit oven_path(oven)

    expect(page).to_not have_content 'Chocolate Chip'
    expect(page).to_not have_content 'Your batch of cookies is Ready'

    click_link_or_button 'Prepare Cookie'
    fill_in 'cookie_cookie_batch_size', with: '0'
    fill_in 'Fillings', with: 'Chocolate Chip'
    click_button 'Mix and bake'

    expect(current_path).to eq(oven_path(oven))
    expect(page).to_not have_content 'Chocolate Chip'
    expect(page).to_not have_content 'Your batch of cookies is Ready'
    expect(page).to have_content 'None'

    visit root_path
    within '.store-inventory' do
      expect(page).to_not have_content '0 Cookie'
    end
  end

  scenario 'Cooking a single cookie' do
    user = create_and_signin
    oven = user.ovens.first

    visit oven_path(oven)

    expect(page).to_not have_content 'Chocolate Chip'
    expect(page).to_not have_content 'Your batch of cookies is Ready'

    click_link_or_button 'Prepare Cookie'
    fill_in 'cookie_cookie_batch_size', with: '1'
    fill_in 'Fillings', with: 'Chocolate Chip'
    click_button 'Mix and bake'

    expect(current_path).to eq(oven_path(oven))
    expect(page).to have_content 'Chocolate Chip'
    expect(page).to have_content 'Your batch of cookies is Ready'
    
    click_button 'Retrieve Cookie'
    expect(page).to_not have_content 'Chocolate Chip'
    expect(page).to_not have_content 'Your batch of cookies is Ready'

    visit root_path
    within '.store-inventory' do
      expect(page).to have_content '1 Cookie'
    end
  end

  scenario 'Trying to bake a cookie while oven is full' do
    user = create_and_signin
    oven = user.ovens.first

    oven = FactoryGirl.create(:oven, user: user)
    visit oven_path(oven)

    click_link_or_button 'Prepare Cookie'
    fill_in 'cookie_cookie_batch_size', with: '1'
    fill_in 'Fillings', with: 'Chocolate Chip'
    click_button 'Mix and bake'

    click_link_or_button  'Prepare Cookie'
    expect(page).to have_content 'A batch of cookies is already in the oven!'
    expect(current_path).to eq(oven_path(oven))
    expect(page).to_not have_button 'Mix and bake'
  end

  scenario 'Baking multiple concurrent cookies (a batch)' do
    user = create_and_signin
    oven = user.ovens.first

    visit oven_path(oven)

    expect(page).to_not have_content 'Chocolate Chip'
    expect(page).to_not have_content 'Your batch of cookies is Ready'

    click_link_or_button 'Prepare Cookie'
    fill_in 'cookie_cookie_batch_size', with: '12'
    fill_in 'Fillings', with: 'Chocolate Chip'
    click_button 'Mix and bake'

    expect(current_path).to eq(oven_path(oven))
    expect(page).to have_content '12 cookies'
    expect(page).to have_content 'Chocolate Chip'
    expect(page).to have_content 'Your batch of cookies is Ready'
    
    click_button 'Retrieve Cookie'
    expect(page).to_not have_content 'Chocolate Chip'
    expect(page).to_not have_content 'Your batch of cookies is Ready'

    visit root_path
    within '.store-inventory' do
      expect(page).to have_content '12 Cookies'
    end
  end

  scenario 'Baking multiple consecutive cookies' do
    user = create_and_signin
    oven = user.ovens.first

    oven = FactoryGirl.create(:oven, user: user)
    visit oven_path(oven)

    3.times do
      click_link_or_button 'Prepare Cookie'
      fill_in 'cookie_cookie_batch_size', with: '1'
      fill_in 'Fillings', with: 'Chocolate Chip'
      click_button 'Mix and bake'

      click_button 'Retrieve Cookie'
    end

    visit root_path
    within '.store-inventory' do
      expect(page).to have_content '3 Cookies'
    end
  end
end
