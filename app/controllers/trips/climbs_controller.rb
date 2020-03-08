class Trips::ClimbsController < ApplicationController
  def new
    @trip = Trip.find(params[:trip_id])
  end

  def index
    @trip = Trip.find(params[:trip_id])

    lat = @trip.lat
    lng = @trip.lng
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
      escape_facade = EscapeFacade.new(params, lat, lng).climb_options
      validate_climb_results(escape_facade)
    end
  end

  def create
    trip = Trip.find(params[:trip_id])
    trip_climb_ids = trip.climbs.pluck(:route_id)
    count = 0
    params["climb_objects"].each do |climb|
      parsed_climb = JSON.parse(climb)
      if trip_climb_ids.include?(parsed_climb["route_id"])
        count += 1
      else
        trip.climbs.create(
          name: parsed_climb["name"],
          route_id: parsed_climb["route_id"],
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
    end
    flash[:notice] = 'One or more of the climbs you selected are already saved to this trip. Only new climbs were added.' if count >= 1
    redirect_to trip_path(trip)
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
