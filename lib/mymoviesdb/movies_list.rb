require 'json'
require_relative 'ancient_movie.rb'
require_relative 'classic_movie.rb'
require_relative 'modern_movie.rb'
require_relative 'new_movie.rb'
require_relative 'recommendation.rb'

module MyMoviesDB
  class MoviesList
    include Recommendation

    attr_reader :movies_list

    def initialize(file_name)
      file = File.open(file_name, 'r') do |f|
        JSON.load(f)
      end
      @movies_list = file.map do |hash|
        Movie.create(hash.map { |k, v| [k.to_sym, v] }.to_h)
      end
    end

    def sort_by_field(field)
      @movies_list.sort_by { |v| v.send(field) }
    end

    def filter_by_field(field)
      @movies_list.map { |v| v.send(field) }.flatten.uniq
    end

    def search_by_field(field, str)
      @movies_list.select { |v| v.send(field).downcase.include? str.downcase }
    end

    def group_by_field(field)
      @movies_list.group_by { |v| v.send(field) }.each { |_, v| v.map!(&:title) }
    end

    def group_by_actor
      @movies_list.map { |m| m.actors.map { |a| [m.title, a] } }
        .flatten(1).group_by(&:last)
        .each { |_, v| v.map!(&:first) }
    end

    def exclude_by(field, str)
      @movies_list.reject { |v| v.send(field) == str }
    end

    def count_by(field)
      group_by_field(field).reduce({}) do |tmp, (k, v)|
        tmp[k] = v.size
        tmp
      end
    end

    def count_by_actor
      actor_list = @movies_list.map(&:actors).flatten
      actor_list.reduce({}) do |hash, k|
        hash[k] = actor_list.count(k)
        hash
      end
    end

    def print_movie(list)
      list.each { |v| puts v.to_s }
    end

    def print(&blk)
      blk ||= proc { |v|  v.to_s }
      @movies_list.each { |v| puts blk.call(v) }
    end

    def sorted_by(sorter = nil, &blk)
      blk ||= proc { |v| @sorters[sorter].call(v) }
      @movies_list.sort_by(&blk)
    end

    def add_sort_algo(fields, &block)
      @sorters ||= {}
      @sorters[fields] = block
    end

    def add_filter(filter, &block)
      @filters ||= {}
      @filters[filter] = block
    end

    def filter(filter_name)
      filter_name.reduce(movies_list) do |acc, (key, val)|
        acc.keep_if do |movie|
          @filters[key].arity > 2 ? @filters[key].call(movie, *val) :
            @filters[key].call(movie, val) 
        end
        acc
      end
    end

  end
end
