require 'rails_helper'

describe "As a logged in User" do
  describe "after completing the search preferences for location and activity" do
    it 'I can see the results of that search' do
      user = create(:user)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit '/profile'

      click_on 'Start a New Trip'

      destination_fixture = File.read('spec/fixtures/boulder.json')
      climb_results = File.read('spec/fixtures/climb_results.json')

      params = {lat: 40.03,
              lon: -105.25,
              max_dist: 10,
              min_diff: 5.7,
              max_diff: 5.12}

      stub_request(:get, "https://escape-app-api.herokuapp.com/api/v1/destination/Boulder").
      to_return(status: 200, body: destination_fixture)

      stub_request(:get, "https://escape-app-api.herokuapp.com/api/v1/climb_results?#{params}").to_return(status: 200, body: climb_results)

      expect(current_path).to eq('/search')

      fill_in "destination", with: "Boulder"

      choose 'Climbing'

      click_on "Continue"

      expect(current_path).to eq('/search/climbs/new')

      select "5.7", from: :min_diff
      select "5.12", from: :max_diff
      check('sport')
      fill_in :distance, with: "10"

      click_on "Find Climbs!"

      expect(current_path).to eq('/trip/new')
      expect("climbs").to_not be_empty
    end
  end
end
