require 'rails_helper'

RSpec.describe 'As a visitor' do
  it 'I can view the welcome page' do
    visit '/'

    expect(page).to have_content('Welcome!')
    expect(page).to have_button('Sign-In with Google')

    within "nav" do
      expect(page).to have_link('About')
    end
  end

  it 'I can visit the about page, then click Log In to return to the root page' do
    visit '/about'
    expect(current_path).to eq('/about')
    click_on 'Log In'
    expect(current_path).to eq('/')
  end
end
