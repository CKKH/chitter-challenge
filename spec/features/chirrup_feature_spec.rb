require_relative 'web_helpers'

RSpec.feature 'Chirrup' do
  context 'Posting a chirrup' do
    scenario 'A user signs in and posts a chirrup' do
      user = create_user('christos', 'christos@makers.com', 'ClassicWoW')
      sign_in
      click_button 'View Chirrups'
      post_chirrup
      expect(page.current_path).to eq('/chirrup-board')
      expect(page).to have_content 'Sqwark!'
    end

    scenario 'A user posts multiple messages and views them in reverse chronological order' do
      user = create_user('christos', 'christos@makers.com', 'ClassicWoW')
      sign_in
      click_button 'View Chirrups'
      fill_in :chirrup, with: 'Sqwark_1!'
      click_button 'Post'
      fill_in :chirrup, with: 'Sqwark_2!'
      click_button 'Post'
      expect('Sqwark_2').to appear_before 'Sqwark_1'
    end
  end

end
