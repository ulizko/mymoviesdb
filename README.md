# Mymoviesdb

This training project. 
Gem `mymoviesdb` pulls out a list of the top 250 movies IMDb and saves it.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mymoviesdb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mymoviesdb

## Usage

### From console

Use `mymoviesdb -h` for details.

#### Update your movies list

    mymoviesdb -u [--path `select where to save list`]
    
#### Show your movies list

    mymoviesdb -s 
    
##### add the output criterion

    mymoviesdb -s -m sort_by_field,duration #=> sorted your list by duration
    
##### show recommendation 5 movies

    mymoviesdb -s -r
    
##### show recommendation only selected genre movies

    mymoviesdb -s -r -g drama

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/mymoviesdb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

