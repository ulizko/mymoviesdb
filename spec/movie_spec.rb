require 'bundler/setup'
require 'rspec/its'
require_relative '../lib/mymoviesdb/movie.rb'
require_relative '../lib/mymoviesdb/modern_movie.rb'
require_relative '../lib/mymoviesdb/ancient_movie.rb'
require_relative '../lib/mymoviesdb/classic_movie.rb'
require_relative '../lib/mymoviesdb/new_movie.rb'
require_relative '../lib/mymoviesdb.rb'

module MyMoviesDB
  RSpec.describe Movie do
    
    let(:hash) do {
                  url: "http://www.imdb.com/title/tt0071562/?ref_=chttp_tt_3",
                  title: "The Godfather: Part II",
                  year: "1974",
                  country: "USA",
                  release: "1974-12-20",
                  genre: "Crime,Drama",
                  duration: "202 min",
                  rating: "9.0",
                  director: "Francis Ford Coppola",
                  actors: "Al Pacino,Robert De Niro,Robert Duvall"
                  }
    end
    subject { Movie.new(hash) }
    
    its(:year) {is_expected.to be_a Fixnum}
    its(:duration) {is_expected.to be_a Fixnum}
    its(:rating) {is_expected.to be_a Float}
    its(:genre) {is_expected.to eq ["Crime", "Drama"]}
    its(:actors) {is_expected.to eq ["Al Pacino", "Robert De Niro", "Robert Duvall"]}
    its(:director) {is_expected.to eq "Francis Ford Coppola"}
    its(:director_surname) {is_expected.to eq "Coppola"}
    its(:release) {is_expected.to be_a String}
    its(:month_name) {is_expected.to eq "December"}
    its(:stars) {is_expected.to eq "**********"}
    
    context 'inherited classes' do
      def movie(params = {}) 
        defaults = { url: "http://www.imdb.com/title/tt0071562/?ref_=chttp_tt_3",
                     title: "The Godfather: Part II",
                     year: "1974",
                     country: "USA",
                     release: "1974-12-20",
                     genre: "Crime,Drama",
                     duration: "202 min",
                     rating: "9.0",
                     director: "Francis Ford Coppola",
                     actors: "Al Pacino,Robert De Niro,Robert Duvall" }
        Movie.create(**defaults.merge(params))
      end
      
      it { expect(movie).to be_an_instance_of ModernMovie }
      it { expect(movie(year: "1950")).to be_an_instance_of ClassicMovie }
      it { expect(movie(year: "1930")).to be_an_instance_of AncientMovie }
      it { expect(movie(year: "2012")).to be_an_instance_of NewMovie }
      context "user rating movie" do
        let(:movie_rated) { movie }
      
        it 'user_rate should be nil' do
          expect(movie_rated.user_rate).to be_nil
        end
        
        it 'time_watch should be nil' do
          expect(movie_rated.time_watch).to be_nil
        end
        
        context "#rate" do
          it "should set user rating" do
            movie_rated.rate(3)
            expect(movie_rated.user_rate).to eq 3
          end
        end
      end
      
      describe ".print_format" do
        let(:default_print) {"The Godfather: Part II is directed by Francis Ford Coppola in 1974, " \
        "played a starring Al Pacino, Robert De Niro, Robert Duvall, Genre: Crime, Drama, " \
        "202 minutes duration. The film premiered in 1974-12-20. Country: USA. Rating: **********"}
        let(:print_movie) {"The Godfather: Part II - is modern movie, starring: Al Pacino, Robert De Niro, Robert Duvall"}
        
        it 'presents format as "The Godfather: Part II - is modern movie, starring: Al Pacino, Robert De Niro, Robert Duvall"' do
          expect{ print print_movie }.to output(movie.print_format).to_stdout
        end
        it 'presents default format' do
          expect{ print default_print }.to output(subject.print_format).to_stdout
        end
      end
    end
  end
end