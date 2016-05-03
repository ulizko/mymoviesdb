require 'bundler/setup'
require 'rspec/its'
require_relative '../lib/mymoviesdb/movie.rb'
require_relative '../lib/mymoviesdb/movies_list.rb'
require_relative '../lib/mymoviesdb/recommendation.rb'

module MyMoviesDB
  RSpec.describe MoviesList do
    
    subject { MoviesList.new("./spec/fixtures/movies.json") }
    
    its("movies_list.size") {is_expected.to eq 20}
    
    
    context "#sort_by_field" do
      it { expect(subject.sort_by_field(:duration)).to be_sorted_by(:duration) }
      
      it "should be return subject" do
        expect(subject.sort_by_field(:producer)).to contain_exactly(*subject.movies_list)
      end
    end
    
    context "#filter_by_field" do
      it "should be return uniq directors" do
        expect(subject.filter_by_field(:director)).to be_uniq
      end
    end
    
    context "#search_by_field" do
      it "should return movies within Knight" do
        expect(subject.search_by_field(:title, "god")).to all(have_attributes( title: /god/i))
      end
    end
    
    context "#exclude_by" do
      let(:exclud) { subject.exclude_by(:country, "USA") }
      it "should return movie without USA " do
        expect(exclud).to all(have_attributes( country: /[^USA]/))
      end
      it "should be not empty" do
        expect(exclud).not_to be_empty
      end
    end
    
    context "#group_by_field" do
      it "should have keys" do
        expect(subject.group_by_field(:country)).to include("USA", "Italy", "France", "New Zealand")
      end
      it "Italy should be size 2" do
        expect(subject.group_by_field(:country)["Italy"].size).to eq 2
      end
    end
    context "#count_by" do
      it "should return count release by month" do
        expect(subject.count_by(:month_name)).to include "December" => 6 
      end
    end
    
    context "#get_recommendation" do
      
      its("get_recommendation.size") {is_expected.to eq 5}
      
      it "should return size of list" do
        expect(subject.get_recommendation(7).size).to eq 7
      end
    end
    
    context "#get_recommendation_watched" do
      it "should return size of list" do
        subject.movies_list.first.rate(5)
        expect(subject.get_recommendation_watched.size).to eq 1
      end
    end
    
    context "#print" do
      it "should print in format present in block" do
        expect{ subject.print { |movie| "#{movie.year}: #{movie.title}" } }.to output(/^\d{4}: \w+/).to_stdout
      end
      
      it "should print in default format" do
        expect{ subject.print }.to output(/.+ - is [modern|new|classic|ancient]+ movie.+/).to_stdout
      end
    end
    
    context "#sorted_by" do
      let(:sorted_list) { subject.sorted_by { |movie| [movie.genre, movie.year] } }
      let(:sorted_algo_list) do
        subject.add_sort_algo(:director_surname_country) { |movie| [movie.director_surname, movie.country] } 
        subject.sorted_by(:director_surname_country)
      end
      it "should return sorted list" do
        expect(sorted_list).to be_sorted_by(:genre, :year)
      end
      it "should return sorted list algo director_surname_country" do
        expect(sorted_algo_list).to be_sorted_by(:director_surname, :country)
      end
    end
    
    context "#filter" do
      let(:filtered_list) do
        subject.add_filter(:released_in_month) { |movie, month| movie.month_name == "December" }
        subject.add_filter(:actor) { |movie, actor|  movie.actors.include?(actor) }
        subject.filter(released_in_month: "December", actor: "Al Pacino")
      end
      
      it "should return filtered list" do
        expect(filtered_list.first).to have_attributes( release: /-12-/, actors: (include("Al Pacino")))
      end
    end
    
  end
end