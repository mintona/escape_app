require 'rails_helper'

describe "As a User" do
  describe "When I have logged in successfully" do
    it "I am on the profile page and can see a button 'Start a New Trip'" do
      user = create(:user)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit '/profile'

      click_on 'Start a New Trip'

      expect(current_path).to eq('/search')
    end
  end

  describe "When I am not logged in" do
    describe "I try to visit the profile page" do
      it "I am redirected to log in page and see a 'Please log in to continue' message" do

        visit '/profile'

        expect(current_path).to eq('/')
        expect(page).to have_content("Please log in to continue")
      end
    end
  end

  describe 'if I have trips' do
    it 'I see a list of trips' do
      user = create(:user, first_name: "Alison")

      trip_1 = create(:trip, user: user)
      trip_2 = create(:trip, user: user)
      trip_3 = create(:trip, user: user)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit '/profile'

      expect(page).to have_css(".trips")

      within("#trip-#{trip_1.id}") do
        expect(page).to have_link("#{trip_1.name}")
      end

      within("#trip-#{trip_2.id}") do
        expect(page).to have_link("#{trip_2.name}")
      end

      within("#trip-#{trip_3.id}") do
        expect(page).to have_link("#{trip_2.name}")
      end
    end

    describe 'if I have no trips' do
      it 'I see text alerting me I have no trips' do
        user = create(:user, first_name: "Alison")

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

        visit '/profile'

        expect(page).to have_css(".trips")

        within(".trips") do
          expect(page).to have_content('You have not added any trips yet.')
        end
      end
    end
  end
end
