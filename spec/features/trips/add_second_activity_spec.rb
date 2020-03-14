require 'rails_helper'

RSpec.describe 'As a logged in user' do
  describe 'I can have both activities on my trip' do
    describe 'if I have created a trip that has climbs' do
      it 'I can add hikes to my trip', js: true do
        VCR.turn_off! :ignore_cassettes => true
        WebMock.allow_net_connect!
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
                    lng: -118.6781,
                    location: "Test Location 1")

        climb_2 = Climb.create!(route_id: 106627453,
                    name: "The Guillotine",
                    climb_type: "Sport",
                    rating: "5.10a/b",
                    stars: 4.4,
                    pitches: 1,
                    url: "https://www.mountainproject.com/route/106627453/the-guillotine",
                    lat: 34.1495,
                    lng: -118.7858,
                    location: "Test Location 2")

        trip_1.climbs << [climb_1, climb_2]

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

        visit trip_path(trip_1.id)

        within '.climbs' do
          expect(page).to have_link(climb_1.name)
          expect(page).to have_link(climb_2.name)
        end

        within '.hikes' do
          expect(page).to have_content('You have not added any hikes yet.')
        end

        click_button 'Add Hikes'

        expect(current_path).to eq("/trips/#{trip_1.id}/search/hikes")

        expect(page).to have_content(trip_1.destination_name)

        fill_in "distance", with: 1
        fill_in "max_results", with: 3
        fill_in 'min_stars', with: 0

        click_button "Find Hikes"

        expect(current_path).to eq("/trips/#{trip_1.id}/search/hikes/index")

        expect(page).to have_css(".hike", count: 3)
        expect(page).to have_content("3 results")

        check "check-box-0"

        expect do
          click_button "Save Selected Hikes"
        end.
        to change { Hike.count}.by(1).and change { Trip.count}.by(0)

        hike = Hike.last

        expect(current_path).to eq("/trips/#{trip_1.id}")

        expect(page).to have_css(".hikes")

        within(".hikes") do
          expect(page).to have_css(".hike", count: 1)

          within("#hike-#{Hike.last.id}") do
            expect(page).to have_content(hike.name)
            click_on hike.name
            expect(page).to have_content(hike.summary)
            expect(page).to have_content(hike.stars)
            expect(page).to have_content(hike.difficulty)
            expect(page).to have_content(hike.high)
            expect(page).to have_content(hike.length)
            expect(page).to have_content(hike.ascent)
            expect(page).to have_link('Link to additional trail details', href: hike.url)
          end
        end
      end

      it 'I am alerted if my search returns no results', :vcr, js: true do

        user = create(:user, first_name: "Alison")
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
        trip_1 = create(:trip, user: user, lng: -101.191819, lat: 37.511714)
        climb = create(:climb, lng: -101.191819, lat: 37.511714)
        trip_1.climbs << climb

        visit trip_path(trip_1.id)
        click_button 'Add Hikes'

        fill_in "distance", with: 1
        fill_in "max_results", with: 3
        fill_in 'min_stars', with: 0

        click_button "Find Hikes"

        expect(page).to have_content('No results returned, please adjust your search and try again.')
        expect(page).to have_button('Find Hikes')
      end
    end

    describe 'I cannot have duplicate results on my trip' do
      it 'I cannot add hikes to my trip that already exist', :vcr, js: true do
        user = create(:user, first_name: "Alison")
        trip_1 = create(:trip, user: user, lng: -118.2436849, lat: 34.0522342)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

        visit trip_path(trip_1.id)

        click_button 'Add Hikes'

        expect(current_path).to eq("/trips/#{trip_1.id}/search/hikes")

        expect(page).to have_content(trip_1.destination_name)

        fill_in "distance", with: 1
        fill_in "max_results", with: 3
        fill_in 'min_stars', with: 0

        click_button "Find Hikes"

        expect(current_path).to eq("/trips/#{trip_1.id}/search/hikes/index")

        check "check-box-0"

        click_button "Save Selected Hikes"

        hike = Hike.last

        expect(current_path).to eq("/trips/#{trip_1.id}")

        expect(page).to have_css(".hikes")

        within(".hikes") do
          expect(page).to have_css(".hike", count: 1)

          within("#hike-#{Hike.last.id}") do
            expect(page).to have_content(hike.name)
          end
        end

        click_button 'Add Hikes'

        expect(current_path).to eq("/trips/#{trip_1.id}/search/hikes")

        expect(page).to have_content(trip_1.destination_name)

        fill_in "distance", with: 1
        fill_in "max_results", with: 3
        fill_in 'min_stars', with: 0

        click_button "Find Hikes"

        expect(current_path).to eq("/trips/#{trip_1.id}/search/hikes/index")

        check "check-box-0"

        expect do
          click_button "Save Selected Hikes"
        end.
        to change { Hike.count}.by(0)

        expect(page).to have_content('One or more of the hikes you selected are already saved to this trip. Only new hikes were added.')

        within(".hikes") do
          expect(page).to have_css(".hike", count: 1)

          within("#hike-#{Hike.last.id}") do
            expect(page).to have_content(hike.name)
          end
        end
      end
    end

    describe 'if I have a trip that has hikes' do
      it 'I can add climbs to my trip', :vcr, js: true do
        user = create(:user)
        trip_1 = create(:trip, lat: 40.0202, lng: -105.2979, user: user)
        hike_1 = create(:hike, trip: trip_1)
        hike_2 = create(:hike, trip: trip_1)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

        visit trip_path(trip_1.id)

        within '.hikes' do
          expect(page).to have_link(hike_1.name)
          expect(page).to have_link(hike_2.name)
        end

        within '.climbs' do
          expect(page).to have_content('You have not added any climbs yet.')
        end

        click_button 'Add Climbs'

        expect(current_path).to eq("/trips/#{trip_1.id}/search/climbs")

        expect(page).to have_content(trip_1.destination_name)

        select "5.7", from: :min_diff
        select "5.12", from: :max_diff
        check "sport"
        fill_in :distance, with: "10"

        click_on "Find Climbs!"

        expect(current_path).to eq("/trips/#{trip_1.id}/search/climbs/index")

        expect(page).to have_css(".climb", count: 11)

        expect(page).to have_content("11 results")

        expect(page).to have_button('Save Selected Climbs', disabled: true)
        check "check-box-0"
        check "check-box-1"

        expect do
          click_button "Save Selected Climbs"
        end.
        to change { Climb.count}.by(2).and change { Trip.count}.by(0)

        climb_1 = Climb.first
        climb_2 = Climb.last

        expect(current_path).to eq("/trips/#{trip_1.id}")

        expect(page).to have_css(".climbs")

        within(".climbs") do
          expect(page).to have_css(".climb", count: 2)

          within("#climb-#{climb_1.id}") do
            expect(page).to have_link(climb_1.name)
            click_on climb_1.name
            expect(page).to have_content(climb_1.rating)
            expect(page).to have_content(climb_1.climb_type)
            expect(page).to have_content(climb_1.stars)
            expect(page).to have_link('Link to additional route details', href: climb_1.url)
          end

          within("#climb-#{climb_2.id}") do
            expect(page).to have_link(climb_2.name)
            click_on climb_2.name
            expect(page).to have_content(climb_2.rating)
            expect(page).to have_content(climb_2.climb_type)
            expect(page).to have_content(climb_2.stars)
            expect(page).to have_link('Link to additional route details', href: climb_2.url)
          end
        end
      end
    end
    #add for no climbs returned
    #add for duplicate climbs
  end
end
