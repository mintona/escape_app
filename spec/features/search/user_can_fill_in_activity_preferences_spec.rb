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

    expect(current_path).to eq('/trip/new')
    expect(page).to have_css(".climbs")
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

    expect(current_path).to eq('/trip/new')
    expect(page).to have_css(".climbs")
  end

  it "max distance does not allow non-numeric value" do
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

    find_field('distance').should have_content('')
  end

  it "returns all climbs if type not selected" do
    WebMock.allow_net_connect!
    user = create(:user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/search'

    fill_in "destination", with: "Boulder"

    choose "Climbing"

    click_button "Continue"

    select "5.7", from: :min_diff
    select "5.12", from: :max_diff
    fill_in :distance, with: "100"

    click_on "Find Climbs!"

    expect(current_path).to eq("/trip/new")
    expect(page).to have_css(".climbs")
  end

  it "returns message if no climbs exist for those params and can return to climb params page" do
    WebMock.allow_net_connect!
    user = create(:user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/search'

    fill_in "destination", with: "Iowa City"

    choose "Climbing"

    click_button "Continue"

    select "5.6", from: :min_diff
    select "5.6", from: :max_diff
    fill_in :distance, with: "10"

    click_on "Find Climbs!"

    expect(current_path).to eq('/trip/new')
    expect(page).to have_content("No climbs exist for those parameters.")
    click_button "Try Again"

    expect(current_path).to eq("/search/climbs/new")
  end

  it "returns flash message if min climb more than max climb" do
    WebMock.allow_net_connect!
    user = create(:user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/search'

    fill_in "destination", with: "Boulder"

    choose "Climbing"

    click_button "Continue"

    select "5.12", from: :min_diff
    select "5.7", from: :max_diff
    check('sport')

    click_on "Find Climbs!"

    expect(current_path).to eq('/search/climbs/new')
    expect(page).to have_content("Maximum difficulty must be more than minimum difficulty.")
  end
end
