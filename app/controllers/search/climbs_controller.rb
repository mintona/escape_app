class Search::ClimbsController < ApplicationController

  def new
    @destination = Destination.new(session[:destination])
  end

  # def index
  #   location = session[:destination]
  #   render locals: {
  #     # climb_results: EscapeService.new.get_climb_results(params, location)
  #   }
  # end

end
