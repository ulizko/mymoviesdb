require_relative 'rateable_movie.rb'


  class ModernMovie < RateableMovie
    
    weight 4
    print_format "%{title} - is modern movie, starring: %{actors}"
    filter { (1969..2000).cover?(year) }
  
  end
