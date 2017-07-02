require "net/http"
require "uri"
require 'active_support/all'
require './analyser'

glob = "dump/out*300.jpg"

league_id = 'LcqfxfuOjc2CypJr908iOhI2'
kartistics_url = 'http://localhost:3000/api/kartalytics/ingest'

uri = URI.parse(kartistics_url)

loop do

  events = []
  Dir.glob(glob).each do |filename|
    event = Analyser.analyse!(filename)

    puts "#{File.basename(filename)} => #{event.inspect}"
    File.rename(filename, filename.to_s.sub('processed', 'out'))

    events.push event
  end

  if events.any?
    payload = {
      league_id: league_id,
      events: events
    }

    request = Net::HTTP::Post.new(uri.path)
    request.content_type = "application/json"
    request.body = payload.to_json

    puts request.body

    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request request
    end

    puts "Sending #{events.length} event(s). Response #{response.body}"
  end
  sleep(0.2)
end

