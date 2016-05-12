require 'date'
require_relative 'recommendation.rb'

module MyMoviesDB
  class Movie
    include Recommendation

    MIN_RATING = 8

    attr_accessor :url, :title, :year, :country, :release, :genre, :duration,
                  :rating, :director, :actors

    def initialize(fields)
      fields.each do |k, v|
        instance_variable_set("@#{k}", v)
      end
    end

    def to_s
      '%s is directed by %s in %s, played a starring %s, ' \
      'Genre: %s, %d minutes duration. The film premiered in %s. ' \
      'Country: %s. Rating: %s' % [title, director, year, actors.join(', '),
      genre.join(', '), duration, release, country, stars]
    end
    # Представляет рейтинг фильма в виде звезд
    # @return [String] одна звезда равна 0.1 рейтинга больше 8.0
    def stars
      rating_star = ((rating - MIN_RATING) * 10).to_i
      ''.ljust(rating_star, '*')
    end

    # @return [String] фамилия режиссера
    def director_surname
      director.split(' ').last
    end
    # Возвращает название месяца релиза фильма
    # @return [String] название месяца 
    def month_name
      str = release
      month = Date.strptime(str[0..6], '%Y-%m').mon
      Date::MONTHNAMES[month]
    end
    # Устанавливает "вес" фильма
    # @param [Integer] 
    def self.weight(weight)
      const_set('WEIGHT', weight)
    end

    def self.year
      @year
    end

    def to_h
      hash_var = instance_variables.map do |var| 
        [var.to_s.sub('@', '').to_sym, instance_variable_get(var)] 
      end.to_h
      hash_var[:actors] = actors.flatten.join(', ')
      hash_var
    end

    def self.print_format(str)
      class_eval("def to_s; \"#{str}\" %self.to_h; end")
    end

    def self.filter(&blk)
      @@filters ||= {}
      @@filters[self] = blk
    end

    def self.create(fields)
      @@filters.each { |name, _| name.instance_variable_set('@year', fields[:year].to_i) }
      type_movie = @@filters.select { |_, block| block.call == true }
      type_movie.keys.first.new(fields)
    end

    def method_missing(method_name, *args)
      raise ArgumentError unless args.empty?
      raise super unless method_name =~ /[a-z]?$/
      genre.include? method_name[0..-2].capitalize
    end
  end
end
