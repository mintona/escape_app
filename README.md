### About Escape

Escape is an interactive application that allows couples and groups to search for climbing and hiking routes near a destination they are looking to travel to. You start by signing in with Google, then pick a destination and first activity (climbing or hiking), then you are directed to a page where you can pick your activity's preferences, such as climb difficulty, type of climbing you are looking to do (Trad or Sport) and land on a page that includes your Trip's information and interactive map with all the routes you added to this trip.

Take a look at Escape's production page at [escape-app](https://escape-app.herokuapp.com/)!


### Purpose Behind the Build

This ten-day group project focused on test-driven development in Ruby on Rails. It also served as a place to practice the skills we have been learning over the past four weeks including OAuth, consuming and exposing APIs, and dividing monolithic applications into microservices.


### Installation

#### Access Locally

This app is intended to work with a microservice we developed, [escape-microservice](https://github.com/mintona/escape_microservice), which was built in Sinatra. Please reference the escape-microservice for installation instructions and endpoint details.


**Clone the Rails app** by running:

`git clone git@github.com:mintona/escape_app.git`

`cd escape-app`

`bundle install`

`rake db:{create,migrate}`

API Keys Required:

For authentication through Google OAuth: [Google Client Id and Google Client Secret](https://console.developers.google.com/cloud-resource-manager)

For interactive maps on trip show pages: [Google Maps API](https://developers.google.com/maps/documentation/javascript/get-api-key)

*Gems Used:*

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


### Using the App



### Versions
- Ruby 2.6.3
- Rails 6.0.2.1


### Database and Schema design

![Schema Description](https://github.com/mintona/escape_app/blob/readme/app/assets/images/schema_design/Screen%20Shot%202020-02-27%20at%201.02.31%20PM.png
  )


### Testing

Our test suite is built in RSpec utilizing Capybara for feature testing.

To run the full test suite, run `bundle exec rspec`

In order to view test coverage, run `open coverage/index.html`


### Future Iterations

In future iterations, the dev team is hoping to include campgrounds to trips, as well as mountain biking and running. Including these activities would enhance the user experience, making it a one stop shop for planning the adventurous side of a vacation.


### Contributors

[Alison Vermeil](https://github.com/mintona)
[Ryan Allen](https://github.com/rallen20)
[Tyla Devon](https://github.com/tyladevon)
[Madelyn R. Romero](https://github.com/madelynrr)
