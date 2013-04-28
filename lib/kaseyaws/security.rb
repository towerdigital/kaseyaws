#!/usr/bin/env ruby
#
# Copyright 2013 by Phillip Henslee (ph2@ph2.us).
# All rights reserved.

# Permission is granted for use, copying, modification, distribution,
# and distribution of modified versions of this work as long as the
# above copyright notice is included.
#

# Provides some helper methods for web service authentication

require 'digest'
require 'net/http'
require 'securerandom'
require 'json'

module KaseyaWS
  class Security

    def self.client_ip
      r =  Net::HTTP.get( 'jsonip.com','/' )
      r = JSON::parse(r)['ip']
    end

    def self.secure_random
      i = SecureRandom.random_bytes
      i = i.each_byte.map { |b| b.to_s }.join
      i = i.gsub("0","")
      i = i[1..8]
    end

    def self.compute_covered_password(username, password, rnd_number, hashing_algorithm)
      if hashing_algorithm == "SHA-1"
        hash1 = Digest::SHA1.hexdigest(password + username)
        covered_password = Digest::SHA1.hexdigest(hash1 + rnd_number)
      else # Assume SHA-256
        hash1 = Digest::SHA256.hexdigest(password + username)
        covered_password = Digest::SHA256.hexdigest(hash1 + rnd_number)
      end
    end

  end
end
