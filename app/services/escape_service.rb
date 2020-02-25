class EscapeService

  def get_destination_info(destination)
    response = location_response(destination)
    JSON.parse(response.body, symbolize_names: true)
  end

  def get_climb_results(params, location)
    response = climbs_response(params, location)
    JSON.parse(response.body, symbolize_names: true)[:routes]
  end

  private

  def connection
    Faraday.new(:url => "https://escape-app-api.herokuapp.com/api/v1") do |faraday|
      faraday.adapter Faraday.default_adapter
    end
  end

  def location_response(destination)
    connection.get do |req|
      req.url ("destination/#{destination}")
    end
  end

  def climbs_response(climb_preferences, location)
    connection.get do |req|
      req.url("climb_results")
      req.params["lat"] = location["lat"]
      req.params["lon"] = location["lng"]
      req.params["min_diff"] = climb_preferences["min_diff"]
      req.params["max_diff"] = climb_preferences["max_diff"]
      req.params["max_dist"] = climb_preferences["distance"]
    end
  end
end
