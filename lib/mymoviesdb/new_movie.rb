require_relative 'rateable_movie.rb'

module MyMoviesDB
  class NewMovie < RateableMovie

    weight 5
    print_format '%{title} - is new movie, grossed more than $100 millions'
    filter { (2001..2016).cover?(year) }
  end
end
