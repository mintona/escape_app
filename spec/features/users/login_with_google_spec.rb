require 'rails_helper'

RSpec.describe 'As a visitor' do
  describe 'when I visit the welcome page' do
    before do
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
    end

    it 'I can register and login with Google Oauth' do
      stub_omniauth

      visit '/'

      expect do
        click_button 'Sign-In with Google'
      end.
      to change { User.count }.by(1)

      user = User.last

      expect(current_path).to eq('/profile')

      within "nav" do
        expect(page).to have_content("Hi, #{user.first_name}")
      end

    end

    it 'I can login as a returning user with Google Oauth' do
      stub_omniauth
      user = create(:user, email: "alison.minton@gmail.com",
                           first_name: "Alison",
                           last_name: "Minton",
                           image: "https://lh3.googleusercontent.com/a-/AAuE7mCBgq8kmZ4WnKkIrlNB5osGhDM8rkQxeh14ZxoxgA")

      visit '/'

      expect do
        click_button 'Sign-In with Google'
      end.
      to change { User.count }.by(0)

      expect(current_path).to eq('/profile')

      expect(User.count).to eq(1)

      within "nav" do
        expect(page).to have_content("Hi, #{user.first_name}")
      end
    end
  end

  describe 'and I am already logged in' do
      it 'I am redirected to my profile page' do

      stub_omniauth
      visit '/'

      click_button 'Sign-In with Google'

      visit '/'
      expect(current_path).to eq(profile_path)
    end
  end
end
