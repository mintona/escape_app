# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
TripClimb.destroy_all
Climb.destroy_all
Trip.destroy_all
User.destroy_all

user = User.create!(first_name: "Amy", last_name: "Smith", email: "hi@gmail.com", google_token: 12345)

climb_1 = Climb.create!(route_id: 106080329,
            name: "The Peacemaker",
            climb_type: "Sport",
            rating: "5.10a",
            stars: 4.5,
            pitches: 7,
            url: "https://www.mountainproject.com/route/106080329/the-peacemaker",
            lat: 34.2709,
            lng: -118.6781)

climb_2 = Climb.create!(route_id: 106627453,
            name: "The Guillotine",
            climb_type: "Sport",
            rating: "5.10a/b",
            stars: 4.4,
            pitches: 1,
            url: "https://www.mountainproject.com/route/106627453/the-guillotine",
            lat: 34.1495,
            lng: -118.7858)

trip = Trip.create!(name: "LA trip",
                  destination_name: "Los Angeles",
                  destination_address: "Los Angeles, CA, USA",
                  lat: 34.0522342,
                  lng: -118.2436849,
                  user: user)

trip.climbs << [climb_1, climb_2]

trip = Trip.create!(name: "Denver Trip",
                  destination_name: "Denver",
                  destination_address: "Denver, CO, USA",
                  lat: 39.7392358,
                  lng: -104.990251,
                  user: user)
