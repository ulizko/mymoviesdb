require 'bundler/setup'
require 'nokogiri'
require 'open-uri'
require 'json'

Scraper = Class.new do
  
  def self.run(path)
    File.open(path, 'w') do |f|
      f.puts JSON.pretty_generate(get_movies)
    end
  end
  
  def self.links
    page = Nokogiri::HTML(open('http://www.imdb.com/chart/top'))
    page.css('table.chart.full-width .titleColumn a').map do |set| 
      "http://www.imdb.com" << set.attributes['href']
        .value.sub(/(?<=[?]).+(?<=[&])/, "") 
    end
  end
  
  def self.get_movies
    
    links.map do |link|
      movie = Nokogiri::HTML(open(link))
      url = link
      title = movie.xpath('//div[@class="title_wrapper"]/h1').children.first.text.gsub(/[[:space:]]+$/, "")
      year = movie.css('h1 a').text
      country = movie.xpath('//div[@id="titleDetails"]/div/a[contains(@href, "/country/")]').children.first.text
      release = movie.css("meta[itemprop='datePublished']")[0].attributes['content'].value
      genre = movie.css("div[itemprop='genre'] a").text.strip.gsub(" ", ",")
      duration = movie.css(".subtext time[itemprop='duration']")[0].attributes["datetime"].value.slice(/\d+/) << " min"
      rating = movie.css("span[itemprop='ratingValue']").text
      # director = movie.css("span[itemprop='director']").first.text.strip.sub(/[,()].+/, "").strip
      director = movie.xpath("//span[@itemprop='director']/a/span[@itemprop='name']").first.text.strip.sub(/[,()].+/, "").strip
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
  end

end


