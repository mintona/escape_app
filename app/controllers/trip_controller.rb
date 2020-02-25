class TripController < ApplicationController
  def new
    @location = session[:destination]
    render locals: {
      climb_results: EscapeFacade.new(params, @location).climb_options
    }
  end
end
