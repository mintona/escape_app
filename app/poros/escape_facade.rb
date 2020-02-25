class EscapeFacade
  def initialize(params, location)
    @params = params
    @location = location
  end

  def climb_options
    results = EscapeService.new.get_climb_results(@params, @location)
    results.map do |result|
      if result[:type] == @params[:trad] || result[:type] == "Sport, TR"
        ClimbOptions.new(result)
      elsif result[:type] == @params[:sport] || result[:type] == "Sport, TR"
        ClimbOptions.new(result)
      elsif !@params.key?(:trad) && !@params.key?(:sport)
        ClimbOptions.new(result)
      end
    end.compact
  end
end
