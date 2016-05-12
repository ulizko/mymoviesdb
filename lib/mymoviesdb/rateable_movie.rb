require_relative 'movie'

module MyMoviesDB
  class RateableMovie < Movie
    attr_reader :user_rate, :time_watch

    def initialize(fields, user_rate = nil, time_watch = nil)
      super(fields)
      @user_rate = user_rate
      @time_watch = time_watch
    end
  end
end
