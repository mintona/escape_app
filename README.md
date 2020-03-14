### About Escape

Escape is an interactive application that allows couples and groups to search for climbing and hiking routes near a travel destination. Start by signing in with Google, then pick a destination (i.e. city, hotel, spa, tourist attraction) and first activity (climbing or hiking). Choose your preferences for the activity, such as climb difficulty, type of climbing (Trad or Sport), distance you are willing to travel from the original destination, and minimum star rating. Save the hikes or climbs you are interested in from the results page and land on a page that includes your Trip's information and an interactive map with all the hikes and/or climbs you added to the trip. You can add more hikes and climbs from the Trip's show page at any time.

Ready to plan your trip? Head over to Escape's production page at [escape-app](https://escape-app.herokuapp.com/)!

### Purpose Behind the Build

This ten-day group project focused on test-driven development in Ruby on Rails and Sinatra. It also served as a place to practice the skills we have been learning over the past four weeks including OAuth, consuming third-party APIs, exposing custom API endpoints, continuious integration/delivery and dividing monolithic applications into microservices. 

### Installation

#### Access Locally

This app is intended to work with a Sinatra microservice we developed, [escape-microservice](https://github.com/mintona/escape_microservice). Please reference the escape-microservice for installation instructions and endpoint details.


**Clone the Rails app** by running:

`git clone git@github.com:mintona/escape_app.git`

`cd escape-app`

`bundle install`

`brew tap homebrew/cask && brew cask install chromedriver` (to install Chromedriver for testing)

`rake db:{create,migrate}`

##### API Keys Required:

For authentication through Google OAuth: [Google Client Id and Google Client Secret](https://console.developers.google.com/cloud-resource-manager)

For interactive maps on trip show pages: [Google Maps API](https://developers.google.com/maps/documentation/javascript/get-api-key)

##### Gems Used:

In Production:
* Faraday
* Figaro
* Omniauth Google OAuth2

For Testing and Development:
* pry
* Capybara
* factory_bot_rails
* launchy
* simplecov
* shoulda-matchers
* vcr
* webmock
* database cleaner active record
* selenium-webdriver

### Ruby and Rails Versions
- Ruby 2.6.3
- Rails 6.0.2.1

### Database and Schema design

![Schema Description](https://github.com/mintona/escape_app/blob/readme/app/assets/images/schema_design/Screen%20Shot%202020-02-27%20at%201.02.31%20PM.png)

### Testing

Our test suite is built in [RSpec](https://github.com/rspec/rspec)utilizing [Capybara](https://github.com/teamcapybara/capybara) and [Selenium](https://github.com/SeleniumHQ/selenium/tree/master/rb) for feature testing. The test coverage is 99%.

To run the full test suite, run `bundle exec rspec`

In order to view test coverage, run `open coverage/index.html`

### Future Iterations

In future iterations, the dev team is hoping to include CRUD functionality for trips so users can edit trip names and delete trips. We would also like to add the ability to add campgrounds and other activities, such as mountain biking and running, to trips. Including these activities would enhance the user experience, making it a one stop shop for planning the adventurous side of a vacation.

### Contributors

[Alison Vermeil](https://github.com/mintona)
[Ryan Allen](https://github.com/rallen20)
[Tyla Devon](https://github.com/tyladevon)
[Madelyn R. Romero](https://github.com/madelynrr)
