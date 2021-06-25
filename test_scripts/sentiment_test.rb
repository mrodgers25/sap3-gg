# frozen_string_literal: true

require 'unirest'

# These code snippets use an open-source library. http://unirest.io/ruby

url = 'http://www.lonelyplanet.com/travel-tips-and-articles/adrenaline-vegas-an-experience-of-sin-city-extremes'
response = Unirest.get "https://loudelement-free-natural-language-processing-service.p.mashape.com/nlp-url/?url=#{url}",
                       headers: {
                         'X-Mashape-Key' => 'OESTJwjxDMmshmb8GOqJX1L3UiaKp1dCRgAjsnQU1Bt9PrLN11',
                         'Accept' => 'application/json'
                       }

puts "Sentiment text is ** #{response.body['sentiment-text']} ** with a score of #{response.body['sentiment-score']}"
