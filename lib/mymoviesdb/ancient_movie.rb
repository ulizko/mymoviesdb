require_relative 'rateable_movie.rb'


  class AncientMovie < RateableMovie
    
    weight 1
    print_format "%{title} — старый фильм (%{year} год)"
    filter { (1900..1945).cover?(year) }
  
  end
