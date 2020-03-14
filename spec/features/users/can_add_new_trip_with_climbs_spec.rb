require 'rails_helper'

RSpec.describe "User can add new trip with climbs" do
  it 'Successful', :vcr, js: true do
    destination = "Boulder"
    distance = "10"
    user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    params = {lat: 40.03,
              lon: -105.25,
              max_dist: 10,
              min_diff: 5.7,
              max_diff: 5.12}

    visit '/search'
    fill_in "destination", with: destination
    choose 'Climbing'
    click_on "Continue"
    expect(current_path).to eq(search_climbs_new_path)

    select "5.7", from: :min_diff
    select "5.12", from: :max_diff
    find(:css, '#sport').click
    fill_in :distance, with: distance

    click_on "Find Climbs!"

    expect(current_path).to eq(climbs_trips_new_path)

    find(:css, "#check-box-0").click
    find(:css, "#check-box-3").click
    find(:css, "#check-box-5").click

    expect do
      click_on 'Save Selected Climbs'
    end.
    to change { Trip.count }.by(1).and change { Climb.count }.by(3)

    new_trip = Trip.last
    selected_climb_1 = Climb.first
    selected_climb_2 = Climb.second
    selected_climb_3 = Climb.third

    expect(current_path).to eq(trip_path(new_trip))
    # auto generated trip name
    expect(page).to have_content("Trip 1: #{destination}")
    expect(page).to have_link(selected_climb_1.name)
    expect(page).to have_link(selected_climb_2.name)
    expect(page).to have_link(selected_climb_3.name)
  end
  
  it "Not successful", :vcr, js: true do
    destination = "Boulder"
    distance = "10"
    user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    params = {lat: 40.03,
              lon: -105.25,
              max_dist: 10,
              min_diff: 5.7,
              max_diff: 5.12}

    visit '/search'
    fill_in "destination", with: destination
    choose 'Climbing'
    click_on "Continue"

    select "5.7", from: :min_diff
    select "5.12", from: :max_diff
    check "sport"
    fill_in :distance, with: distance
    click_on "Find Climbs!"

    expect(page).to have_button('Save Selected Climbs', disabled: true)
    find(:css, "#check-box-0").set(true)
    expect(page).to have_button('Save Selected Climbs', disabled: false)
  end
end
