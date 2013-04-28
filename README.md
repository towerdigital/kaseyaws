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

Create a new web service client

kclient = KaseyaWS::Client.new("username","password","mykserver.domain.com")

Get all alarms, returns hash table

alarms = kclient.get_all_alarms
