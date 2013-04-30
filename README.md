# KaseyaWS

A simple Ruby Gem that provides a Ruby client for Kaseya's VSA web service.

This is currently a work in progress, as all Kaseya web service operations are not yet implemented.

[The offical documentation for the Kaseya VSA web service](http://tinyurl.com/kaseyavsaws)

## Installation

KaseyaWS is available at [Rubygems](http://rubygems.org/gems/kaseyaws) and can be installed as follows.

```
$ gem install kaseyaws
```

or add it to your Gemfile:

```
gem 'kaseyaws', '~> 0.0.5'
```

## Usage

``` ruby
require 'kaseyaws'

# Create a new web service client instance
kclient = KaseyaWS::Client.new("username","password","mykserver.domain.com")

#Get alarm list, returns hash
alarms = kclient.get_alarm_list

#Get a specific alarm by alarm id, returns hash
alarm = kclient.get_alarm(alarms[:alarms][:alarm][0][:monitor_alarm_id])

alarm[:alarm_subject]
# => "Monitoring generated Counter ALARM at 5:47:54 am 01-Feb-13 on computer.systems.company"

```
## Dependencies

KaseyaWS has two Gem dependencies, Savon and json.

[Savon](http://savonrb.com/) 

The Heavy metal SOAP client Savon does most of the work.

[JSON](http://flori.github.com/json)

A Ruby implementation for JSON.

