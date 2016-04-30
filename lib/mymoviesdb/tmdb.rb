require 'bundler/setup'
require 'themoviedb-api'
require "date"

module Mymoviesdb
  class MovieDB
    
    API_KEY = "49f9fa36e35148764b75d87d4a894fa2"
    RESULT_ON_PAGE = 20
    Tmdb::Api.key(API_KEY)
    
    attr_reader :detail
    
    def MovieDB.build
      @movies_list = get_list.map do |tmdb|
        id = tmdb.id
        movie = new(id)
          { title: movie.title,
            year: movie.year,
            country: movie.country,
            release: movie.release,
            genre: movie.genre,
            duration: movie.duration,
            rating: movie.rating,
            director: movie.director,
            actors: movie.actors }
      end
    end
    def initialize(id)
      sleep(0.2)
      @detail = Tmdb::Movie.detail(id)
    end
    
    def title
      detail.title
    end
    
    def year
      Date.strptime(release, "%Y-%m-%d").year
    end
    
    def release
      detail.release_date
    end
    
    def country
      detail.production_countries.map(&:name)
    end
    
    def genre
      detail.genres.map(&:name).sort
    end
    
    def duration
      detail.runtime
    end
    
    def rating
      detail.vote_average
    end
    
    def director
      Tmdb::Movie.director(id).map(&:name).first
    end
    
    def actors
      Tmdb::Movie.cast(id).map(&:name).first(3)
    end
    
    def id
      detail.id
    end
    
    def MovieDB.get_list(size = 240)
      result ||= []
      pages = size.div(RESULT_ON_PAGE).zero? ? 1 : size.div(RESULT_ON_PAGE)
      1.upto(pages) { |num| result += get_page(num) }
      result
    end
    
    def MovieDB.get_page(page)
      Tmdb::Movie.top_rated(page: page).results
    end
    
  end
end