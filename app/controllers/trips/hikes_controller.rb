class Trips::HikesController < ApplicationController
  def new
    @trip = Trip.find(params[:trip_id])
  end

  def index
    trip = Trip.find(params[:trip_id])
    hikes_facade = TripHikesFacade.new(trip, params)

    if hikes_facade.number_of_hikes == 0
        flash[:notice] = "No results returned, please adjust your search and try again."
        redirect_to "/trips/#{trip.id}/search/hikes"
    else
      render locals: {
        hikes_facade: hikes_facade
      }
    end
  end

  def create
    trip = Trip.find(params[:trip_id])
    trip_rids = trip.hikes.pluck(:rid)
    hikes = params["hike_objects"]
    count = 0
    hikes.each do |hike|
      hike_params = parsed_hike(hike)
      if trip_rids.include?(hike_params[:rid])
        count +=1
      else
        trip.hikes.create!(hike_params)
      end
    end
    flash[:notice] = 'One or more of the hikes you selected are already saved to this trip. Only new hikes were added.' if count >= 1
    redirect_to trip_path(trip)
  end

  private

  def parsed_hike(hike_data)
    parsed_data = JSON.parse(hike_data)
    {
     name: parsed_data["name"],
     rid: parsed_data["rid"],
     url: parsed_data["url"],
     lat: parsed_data["lat"],
     lng: parsed_data["lng"],
     summary: parsed_data["summary"],
     difficulty: parsed_data["difficulty"],
     stars: parsed_data["stars"],
     location: parsed_data["location"],
     length: parsed_data["length"],
     ascent: parsed_data["ascent"],
     high: parsed_data["max_elevation"]
   }
  end
end
