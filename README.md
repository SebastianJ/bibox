# Bibox REST + Websocket client in Ruby

This gem provides a REST client and a Websocket client to interact with the crypto currency exchange Bibox. Bibox is an up and coming exchange that's very similar to Binance and KuCoin.

## Getting started

First you'll need to get an account on Bibox, [click here to get one](https://www.bibox.com/login/register?id=11154920&lang=en).

After setting up your account, head to "Account Information", locate the "API" section and click on "Add".
Enter a name/comment for your key, e.g. "Bibox Ruby", and proceed to click on "Create".
Copy the API key and the secret that was just created for you.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bibox'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bibox

## Setup

```ruby
Bibox.configure do |config|
  config.key = YOUR_API_KEY
  config.secret = YOUR_API_SECRET
end
```

## Usage

REST Client (see specs/source code for available methods/endpoints):

```ruby
client = Bibox::Rest::Client.new
client.pairs
```

Websocket client

See bin/websocket for a reference implementation of websockets.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/SebastianJ/bibox. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Bibox project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/SebastianJ/bibox/blob/master/CODE_OF_CONDUCT.md).
