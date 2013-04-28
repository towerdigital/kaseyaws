# KaseyaWS

A simple Ruby client for Kaseya's VSA web service.

## Installation

Add this line to your application's Gemfile:

    gem 'kaseyaws'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kaseyaws

## Usage

Create a new web service client instance

>> kclient = KaseyaWS::Client.new("username","password","mykserver.domain.com")

Get all alarms, returns hash

>> alarms = kclient.get_alarm_list

Get a specific alarm by alarm id, returns hash

>> alarm = kclient.get_alarm(alarms[:alarms][:alarm][0][:monitor_alarm_id])

alarm[:alarm_subject]

=> => "Monitoring generated Counter ALARM at 5:47:54 am 01-Feb-13 on computer.systems.company"

