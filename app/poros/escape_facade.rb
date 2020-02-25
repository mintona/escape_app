class EscapeFacade
  def initialize(params, location)
    @params = params
    @location = location
  end 

  def climb_options
    results = EscapeService.new.get_climb_results(@params, @location)
    results.map do |result|
      if result[:type] == @params[:type] || result[:type] == "Sport, TR"
        ClimbOptions.new(result)
      end 
    end.compact
  end
end 