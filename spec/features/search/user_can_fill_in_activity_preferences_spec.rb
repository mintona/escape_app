require 'rails_helper'

describe "As a logged-in User, after choosing destination and activity" do
  VCR.turn_off! :ignore_cassettes => true
  it "can select activity preferences (for climbing) and get back climbing routes" do
    WebMock.allow_net_connect!

    user = create(:user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/search'

    fill_in "destination", with: "Boulder"

    choose "Climbing"

    click_button "Continue"

    expect(current_path).to eq('/search/climbs/new')

    select "5.7", from: :min_diff
    select "5.12", from: :max_diff
    check('sport')
    fill_in :distance, with: "10"

    click_on "Find Climbs!"

    expect(current_path).to eq("/search/climbs")
    expect(page).to have_css(".climb")
  end

  it "displays climbs if no max distance is put in" do
    WebMock.allow_net_connect!
    user = create(:user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/search'

    fill_in "destination", with: "Boulder"

    choose "Climbing"

    click_button "Continue"

    select "5.7", from: :min_diff
    select "5.12", from: :max_diff
    check('sport')

    click_on "Find Climbs!"

    expect(current_path).to eq("/search/climbs")
    expect(page).to have_css(".climb")
  end

  it "returns error message if distance is not valid" do
    WebMock.allow_net_connect!
    user = create(:user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/search'

    fill_in "destination", with: "Boulder"

    choose "Climbing"

    click_button "Continue"

    select "5.7", from: :min_diff
    select "5.12", from: :max_diff
    check('sport')
    fill_in :distance, with: "AA"

    click_on "Find Climbs!"

    expect(current_path).to eq("/search/climbs/new")
    expect(page).to have_content("Please enter a valid maximum distance.")
  end

  it "returns error message if type not selected" do
    WebMock.allow_net_connect!
    user = create(:user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/search'

    fill_in "destination", with: "Boulder"

    choose "Climbing"

    click_button "Continue"

    select "5.7", from: :min_diff
    select "5.12", from: :max_diff
    fill_in :distance, with: "AA"

    click_on "Find Climbs!"

    expect(current_path).to eq("/search/climbs/new")
    expect(page).to have_content("Please choose a climb type.")
  end
end
