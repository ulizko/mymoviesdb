require 'bundler/setup'
require 'nokogiri'
require 'open-uri'
require 'json'


page = Nokogiri::HTML(open('http://www.imdb.com/chart/top'))
ADDRESS = "http://www.imdb.com"

links = page.css('table.chart.full-width .titleColumn a')
  .map { |set| "http://www.imdb.com" << set.attributes['href'].value.sub(/(?<=[?]).+(?<=[&])/, "") }
movies = links.map do |link|
  movie = Nokogiri::HTML(open(link))
  url = link
  title = movie.xpath('//div[@class="title_wrapper"]/h1').children.first.text.gsub(/[[:space:]]+$/, "")
  year = movie.css('h1 a').text
  country = movie.xpath('//div[@id="titleDetails"]/div/a[contains(@href, "/country/")]').children.first.text
  release = movie.css("meta[itemprop='datePublished']")[0].attributes['content'].value
  genre = movie.css("div[itemprop='genre'] a").text.strip.gsub(" ", ",")
  duration = movie.css(".subtext time[itemprop='duration']")[0].attributes["datetime"].value.slice(/\d+/) << " min"
  rating = movie.css("span[itemprop='ratingValue']").text
  director = movie.css("span[itemprop='director']").text.strip.sub(/[,()].+/, "").strip
  actors = movie.css("span[itemprop='actors']").text.split(",").map(&:strip).join(",")
  {
    url: url, 
    title: title, 
    year: year, 
    country: country, 
    release: release, 
    genre: genre, 
    duration: duration, 
    rating: rating, 
    director: director, 
    actors: actors
    }
end

puts JSON.pretty_generate(movies)


