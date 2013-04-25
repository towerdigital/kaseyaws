# KaseyaWS

A simple Ruby client for Kaseya VSA web service.

## Installation

Add this line to your application's Gemfile:

    gem 'kaseyaws'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kaseyaws

## Usage

Example Usage:

Create a new web service client

kclient = KaseyaWS::Client("username","password","mykserver.domain.com")

Get all a list of all of the alarms

alarms = kclient.get_all_alarms("true")

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
