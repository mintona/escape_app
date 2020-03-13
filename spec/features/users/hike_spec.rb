require 'rails_helper'

RSpec.describe "As a logged in user" do
  describe 'I can make a new trip with hikes' do
    it "by entering a location that has hikes", :vcr, js: true do
      user = create(:user)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit '/search'

      fill_in "destination", with: "Boulder"

      choose "Hiking"

      click_button "Continue"

      expect(current_path).to eq("/search/hikes/new")
      expect(page).to have_content("Boulder")

      fill_in "distance", with: 1
      fill_in "max_results", with: 3
      fill_in 'min_stars', with: 0

      click_button "Find Hikes"

      expect(current_path).to eq("/hikes/trips/new")

      expect(page).to have_css(".hike", count: 3)
      expect(page).to have_content("3 results")

      within "#hike-result-0" do
        expect(page).to have_link("Dakota Ridge to Sanitas Valley Loop", href: "https://www.hikingproject.com/trail/7006781/dakota-ridge-to-sanitas-valley-loop")
        expect(page).to have_content("A technical ascent with a great view of Boulder, followed by a nice, open downhill pitch.")
        expect(page).to have_content("blue")
        expect(page).to have_content(4)
        expect(page).to have_content("Boulder, Colorado")
        expect(page).to have_content(2.3)
        expect(page).to have_content(458)
        expect(page).to have_content(5961)
      end

      within "#hike-result-1" do
        expect(page).to have_content("Mount Sanitas Loop")
      end

      within "#hike-result-2" do
        expect(page).to have_content("Sunshine Lion's Lair Loop")
      end

      expect(page).to have_button("Save Selected Hikes", disabled: true)

      check "check-box-0"
      check "check-box-1"
      check "check-box-2"

      expect do
        click_button "Save Selected Hikes"
      end.
      to change { Hike.count}.by(3).and change { Trip.count}.by(1)

      trip = Trip.last

      expect(current_path).to eq("/trips/#{trip.id}")

      expect(page).to have_css(".hikes")

      within(".hikes") do
        expect(page).to have_css(".hike", count: 3)
        within "#hike-#{Hike.first.id}" do
          click_link ("Dakota Ridge to Sanitas Valley Loop")
          expect(page).to have_content("A technical ascent with a great view of Boulder, followed by a nice, open downhill pitch.")
          expect(page).to have_content("blue")
          expect(page).to have_content(4)
          expect(page).to have_content("Boulder, Colorado")
          expect(page).to have_content(2.3)
          expect(page).to have_content(458)
          expect(page).to have_content(5961)
          expect(page).to have_link('Link to additional trail details', href: "https://www.hikingproject.com/trail/7006781/dakota-ridge-to-sanitas-valley-loop")
        end

        within "#hike-#{Hike.second.id}" do
          expect(page).to have_content("Mount Sanitas Loop")
        end

        within "#hike-#{Hike.last.id}" do
          expect(page).to have_content("Sunshine Lion's Lair Loop")
        end
      end
      expect(page).to have_css("#map")
    end

    describe 'if my search has no results I am notified with a flash message' do
      it "can do hikes", :vcr do
        user = create(:user)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

        visit '/search'

        fill_in "destination", with: "Grant County, KS"

        choose "Hiking"

        click_button "Continue"

        expect(current_path).to eq("/search/hikes/new")
        expect(page).to have_content("Grant County")

        fill_in "distance", with: 1
        fill_in "max_results", with: 3
        fill_in 'min_stars', with: 0

        click_button "Find Hikes"

        expect(page).to have_content('No results returned, please adjust your search and try again.')

        expect(current_path).to eq('/search/hikes/new')
      end
    end
  end
end
