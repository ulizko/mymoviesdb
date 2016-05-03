%w(bundler/setup nokogiri open-uri json ruby-progressbar mymoviesdb)
  .each { |v| require v }

module MyMoviesDB
  class Scraper
    attr_reader :path

    def initialize(path)
      @path = path
      @bar = progress
    end

    def run
      File.open(path, 'w') do |f|
        f.puts JSON.pretty_generate(get_movies)
      end
    end

    private

    def links
      page = Nokogiri::HTML(open('http://www.imdb.com/chart/top'))
      page.css('table.chart.full-width .titleColumn a').map do |set|
        'http://www.imdb.com' << set.attributes['href'].value.sub(/(?<=[?]).+(?<=[&])/, '') 
      end
    end

    def get_movies
      links.map do |link|
        @bar.increment
        movie = Nokogiri::HTML(open(link))
        url = link
        title = movie.xpath('//div[@class="title_wrapper"]/h1').children.first.text.gsub(/[[:space:]]+$/, '')
        year = movie.css('h1 a').text.to_i
        country = movie.xpath('//div[@id="titleDetails"]/div/a[contains(@href, "/country/")]').children.first.text
        release = movie.css("meta[itemprop='datePublished']")[0].attributes['content'].value
        genre = movie.css("div[itemprop='genre'] a").text.strip.split(' ')
        duration = movie.css(".subtext time[itemprop='duration']")[0].attributes['datetime'].value.slice(/\d+/).to_i
        rating = movie.css("span[itemprop='ratingValue']").text.to_f
        director = movie.xpath("//span[@itemprop='director']/a/span[@itemprop='name']").first.text.strip.sub(/[,()].+/, '').strip
        actors = movie.css("span[itemprop='actors']").text.split(',').map(&:strip)
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
    
    def progress
      ProgressBar
        .create(length: 150, total: 250, format: '%a %B %p%% %t')
    end
  end
end
