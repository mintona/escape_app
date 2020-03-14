class Search::HikesController < ApplicationController
  before_action :require_current_user

  def new
    @destination = Destination.new(session[:destination])
  end
end
