class HikesFacade
  def initialize(destination, search_params)
    @destination = Destination.new(destination)
    @search_params = search_params
  end

  def destination_name
    @destination.name
  end

  def destination_address
    @destination.address
  end

  def number_of_hikes
    hike_results.count
  end

  def hike_results
    @hike_results ||= get_hike_results
  end

  private

  def get_hike_results
    all_hikes = EscapeService.new.get_hike_results(@search_params, @destination.lat, @destination.lng)
    hike_results = all_hikes.map do |hike_response|
      HikeOption.new(hike_response)
    end
  end
end
