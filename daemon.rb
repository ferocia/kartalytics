require "net/http"
require "uri"
require 'retriable'
require 'active_support/all'
require './analyser'

glob = "dump/out*.jpg"

raise("You must set a POST_URL env variable - this is where kartalytics will send its data") if ENV['POST_URL'].blank?

keep_files = !!ENV['KEEP_FILES']
uri = URI.parse(ENV['POST_URL'])

KartLog = ActiveSupport::Logger.new('analyser.log')

loop do
  events = []

  Dir.glob(glob).sort_by {|file|
    File.ctime(file)
  }.each do |filename|
    event = nil

    start = Time.now

    begin
      event = Analyser.analyse!(filename)

      KartLog.info "#{File.basename(filename)} => #{event.inspect} - Time taken: #{Time.now - start}"
    rescue Magick::ImageMagickError => e
      KartLog.error "RMagick error #{e}"
    end

    if keep_files
      new_name = filename.to_s.sub('out', 'processed')
      File.rename(filename, new_name)
    else
      File.unlink(filename)
    end

    events.push(event) if event
  end

  if events.any?
    payload = {
      events: events
    }

    request = Net::HTTP::Post.new(uri.path)
    request.content_type = "application/json"
    request.body = payload.to_json

    KartLog.info request.body
    response = nil

    Retriable.retriable on: [Timeout::Error, Errno::ECONNRESET] do
      response = Net::HTTP.start(uri.host, uri.port) do |http|
        http.request request
      end
    end

    KartLog.info "Sending #{events.length} event(s). Response #{response.body}"
  end
  sleep(0.1)
end

