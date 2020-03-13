class TripHikesFacade
  def initialize(trip, search_params)
    @trip = trip
    @search_params = search_params
  end

  def trip_id
    @trip.id
  end

  def destination_name
    @trip.destination_name
  end

  def destination_address
    @trip.destination_address
  end

  def number_of_hikes
    hike_results.count
  end

  def hike_results
    @hike_results ||= get_hike_results
  end

  private

  def get_hike_results
    all_hikes = EscapeService.new.get_hike_results(@search_params, @trip.lat, @trip.lng)
    hike_results = all_hikes.map do |hike_response|
      HikeOption.new(hike_response)
    end
  end
end
