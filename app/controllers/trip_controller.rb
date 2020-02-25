class TripController < ApplicationController
  def new
    if Integer(params[:min_diff].split('.').last) > Integer(params[:max_diff].split('.').last)
      flash[:error] = "Maximum difficulty must be more than minimum difficulty."
      redirect_to "/search/climbs/new"
    else
    @location = session[:destination]
    render locals: {
      climb_results: EscapeFacade.new(params, @location).climb_options
    }
    end
  end
end
