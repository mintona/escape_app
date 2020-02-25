class ClimbOptions
  attr_reader :name, :climb_type, :rating, :stars, :pitches, :location, :url
  def initialize(info)
    @name = info[:name]
    @climb_type = info[:type]
    @rating = info[:rating]
    @stars = info[:stars]
    @pitches = info[:pitches]
    @location = info[:location].join(',')
    @url = info[:url]
  end 
end