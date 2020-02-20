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
end
