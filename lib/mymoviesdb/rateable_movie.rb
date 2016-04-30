require_relative 'movie'


  class RateableMovie < Movie
    
    attr_reader :user_rate, :time_watch 
    
    def initialize(fields, user_rate = nil, time_watch = nil)
      super(fields)
      @user_rate, @time_watch = user_rate, time_watch
    end
    
  end
