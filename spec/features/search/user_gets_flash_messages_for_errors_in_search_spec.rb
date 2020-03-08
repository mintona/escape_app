require 'rails_helper'

describe "As a logged-in User, after choosing destination and activity" do
  describe "if climbing difficulty range is out of order" do
    VCR.turn_off! :ignore_cassettes => true
    it "will be redirected back to search again and see a flash message prompting correct order" do
      WebMock.allow_net_connect!

      user = create(:user)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit '/search'

      fill_in "destination", with: "Boulder"

      choose "Climbing"

      click_button "Continue"

      expect(current_path).to eq('/search/climbs/new')

      select "5.9", from: :min_diff
      select "5.7", from: :max_diff
      check "sport"
      fill_in :distance, with: "10"

      click_on "Find Climbs!"
      
      expect(current_path).to eq('/search/climbs/new')
      expect(page).to have_content("Please ensure your minimium difficulty is less than your maximum difficulty in your selection preferences")
    end
  end
  describe "if distance is less than or equal to zero, or left blank" do
    it "I will be redirected back to the search page and see an error message" do
      WebMock.allow_net_connect!

      user = create(:user)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit '/search'

      fill_in "destination", with: "Boulder"

      choose "Climbing"

      click_button "Continue"

      expect(current_path).to eq('/search/climbs/new')

      select "5.6", from: :min_diff
      select "5.7", from: :max_diff
      check "sport"
      fill_in :distance, with: "-5"

      click_on "Find Climbs!"

      expect(current_path).to eq('/search/climbs/new')
      expect(page).to have_content("Please fill in a distance of at least 1 and try your search again")
    end 
  end
    describe "if both distance and difficulty are entered incorrectly" do
      it "user will be redirected back to the search page and an error message will be displayed" do
      WebMock.allow_net_connect!
  
      user = create(:user)
  
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  
      visit '/search'
  
      fill_in "destination", with: "Boulder"
  
      choose "Climbing"
  
      click_button "Continue"
  
      expect(current_path).to eq('/search/climbs/new')
  
      select "5.9", from: :min_diff
      select "5.7", from: :max_diff
      check "sport"
      fill_in :distance, with: "-5"
  
      click_on "Find Climbs!"
  
      expect(current_path).to eq('/search/climbs/new')
      expect(page).to have_content("Please ensure your minimium difficulty is less than your maximum difficulty in your selection preferences and you have a distance of at least 1 mile")
    end 
  end
    describe "if the search comes back with no results" do
      it "I will be redirected back to the search page and see a message to try my search again" do
      WebMock.allow_net_connect!
  
      user = create(:user)
  
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  
      visit '/search'
  
      fill_in "destination", with: "Knoxville"
  
      choose "Climbing"
  
      click_button "Continue"
  
      expect(current_path).to eq('/search/climbs/new')
  
      select "5.6", from: :min_diff
      select "5.6", from: :max_diff
      check "trad"
      fill_in :distance, with: "2"
  
      click_on "Find Climbs!"
  
      expect(current_path).to eq('/search/climbs/new')
      expect(page).to have_content("No results returned, please adjust your search and try again")
    end 
  end
end
