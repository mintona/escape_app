require 'rails_helper'

RSpec.describe 'As a logged in user' do
  describe 'I can visit a trip show page' do
    it 'to see all details about the trip' do
      user = create(:user, first_name: "Alison")
      trip_1 = create(:trip, user: user, lng: -118.2436849, lat: 34.0522342)
      climb_1 = Climb.create!(route_id: 106080329,
                  name: "The Peacemaker",
                  climb_type: "Sport",
                  rating: "5.10a",
                  stars: 4.5,
                  pitches: 7,
                  url: "https://www.mountainproject.com/route/106080329/the-peacemaker",
                  lat: 34.2709,
                  lng: -118.6781)

      climb_2 = Climb.create!(route_id: 106627453,
                  name: "The Guillotine",
                  climb_type: "Sport",
                  rating: "5.10a/b",
                  stars: 4.4,
                  pitches: 1,
                  url: "https://www.mountainproject.com/route/106627453/the-guillotine",
                  lat: 34.1495,
                  lng: -118.7858)

      trip_1.climbs << [climb_1, climb_2]
      trip_2 = create(:trip, user: user)
      climb_3 = create(:climb)
      climb_4 = create(:climb)
      trip_2.climbs << [climb_3, climb_4]

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit '/profile'

      expect(page).to have_css(".trips")

      within("#trip-#{trip_1.id}") do
        click_link "#{trip_1.name}"
      end

      expect(current_path).to eq("/trips/#{trip_1.id}")

      expect(page).to have_content("#{trip_1.name}")
      expect(page).to have_content("#{trip_1.destination_name}")
      expect(page).to have_content("#{trip_1.destination_address}")

      expect(page).to have_css(".climbs")

      within ".climbs" do
        within "#climb-#{climb_1.id}" do
          expect(page).to have_link("#{climb_1.name}", href: climb_1.url)
          expect(page).to have_content(climb_1.climb_type)
          expect(page).to have_content(climb_1.rating)
          expect(page).to have_content(climb_1.stars)
        end

        within ("#climb-#{climb_2.id}") do
          expect(page).to have_link("#{climb_2.name}", href: climb_2.url)
          expect(page).to have_content(climb_2.climb_type)
          expect(page).to have_content(climb_2.rating)
          expect(page).to have_content(climb_2.stars)
        end
        
        expect(page).to_not have_link("#{climb_3.name}", href: climb_3.url)
        expect(page).to_not have_link("#{climb_4.name}", href: climb_4.url)
      end

      expect(page).to have_css(".google-map")
      expect(page).to have_css("#map")
      expect("#map").to_not be_empty
    end

    describe 'if I have not added any climbs' do
      it 'I will still see the map with my destination pin' do
        user = create(:user, first_name: "Alison")
        trip_1 = create(:trip, user: user, lng: -118.2436849, lat: 34.0522342)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

        visit "/trips/#{trip_1.id}"

        expect(page).to have_css("#map")
        expect("#map").to_not be_empty
      end

      it 'I see text alerting me I have not added any climbs yet' do
        user = create(:user, first_name: "Alison")
        trip_1 = create(:trip, user: user, lng: -118.2436849, lat: 34.0522342)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

        visit "/trips/#{trip_1.id}"

        within ".climbs" do
          expect(page).to have_content('You have not added any climbs yet.')
        end
      end
    end
  end
end
