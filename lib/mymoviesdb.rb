require 'bundler/setup'
require 'mymoviesdb/version'
require_relative 'mymoviesdb/movies_list'

module Mymoviesdb
  
  def Mymoviesdb.show
    path = "./data/movies.json"
    list = MoviesList.new(path)
    list.print
  end

end
