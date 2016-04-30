require_relative 'rateable_movie.rb'


  class ClassicMovie < RateableMovie
    
    weight 1
    print_format "%{title} - is classic movie, director: %{director}"
    filter { (1946..1968).cover?(year) }
  end
