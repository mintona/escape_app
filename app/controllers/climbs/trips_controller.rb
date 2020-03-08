class Climbs::TripsController < ApplicationController
  before_action :require_current_user
  def new
    @location = session[:destination]
    diff_list = ["5.6", "5.7","5.8", "5.9", "5.10", "5.11", "5.12", "5.13"]

    min_diff = diff_list.find_index(params["min_diff"])
    max_diff = diff_list.find_index(params["max_diff"])

    if min_diff > max_diff && params["distance"].to_i <= 0
      flash[:error] = "Please ensure your minimium difficulty is less than your maximum difficulty in your selection preferences and you have a distance of at least 1 mile"
      redirect_to '/search/climbs/new'
    elsif params["distance"].to_i <= 0
      flash[:error] = "Please fill in a distance of at least 1 and try your search again"
      redirect_to '/search/climbs/new'
    elsif min_diff > max_diff
      flash[:error] = "Please ensure your minimium difficulty is less than your maximum difficulty in your selection preferences"
      redirect_to '/search/climbs/new'
    else
      escape_facade = EscapeFacade.new(params, @location["lat"], @location["lng"]).climb_options
      validate_climb_results(escape_facade)
    end
  end

  def create
    destination = session["destination"]
    new_trip = current_user.trips.create(
      name: "Trip #{current_user.trips.count + 1}: #{destination["name"]}",
      destination_name: destination["name"],
      destination_address: destination["address"],
      lat: destination["lat"],
      lng: destination["lng"]
    )
    params["climb_objects"].each do |climb|
      parsed_climb = JSON.parse(climb)
      new_trip.climbs.create(
        name: parsed_climb["name"],
        rating: parsed_climb["rating"],
        stars: parsed_climb["stars"],
        pitches: parsed_climb["pitches"],
        location: parsed_climb["location"],
        lat: parsed_climb["latitude"],
        lng: parsed_climb["longitude"],
        climb_type: parsed_climb["climb_type"],
        url: parsed_climb["url"]
      )
    end
    redirect_to trip_path(new_trip)
  end

  private

  def validate_climb_results(escape_facade)
    if escape_facade.length == 0
        flash[:error] = "No results returned, please adjust your search and try again"
        redirect_to '/search/climbs/new'
    else
      render locals: {
        climb_results: escape_facade
      }
    end
  end
end
