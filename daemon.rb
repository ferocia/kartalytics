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

# Analyse every 5th image by default - we'll change this
# when we're expecting an intro screen (these are often skipped)
DEFAULT_SAMPLE_RATE = 5
sample_rate = DEFAULT_SAMPLE_RATE

def should_sample?(filename, sample_rate)
  File.basename(filename).gsub(/[^\d]/, '').to_i % sample_rate == 0
end

def should_increase_sample_rate?(event)
  # If we've seen a loading screen, next screen we're likely to see
  # is an intro screen - lets bump sample rate to try to grab it
  event[:event_type] == 'loading_screen'
end

def should_decrease_sample_rate?(event)
  # If we've seen any of these screens we don't need to sample faster for a bit
  event[:event_type] == 'intro_screen' ||
  event[:event_type] == 'race_screen' ||
  event[:event_type] == 'main_menu_screen'
end

loop do
  events = []

  begin
    Dir.glob(glob).sort_by {|file|
      # File.ctime(file)
      File.basename(file)
    }.each do |filename|
      event = nil

      if should_sample?(filename, sample_rate)
        start = Time.now
        event = Analyser.analyse!(filename)

        KartLog.info "#{File.basename(filename)} => #{event.inspect} - Time taken: #{Time.now - start}"
      else
        KartLog.info "#{File.basename(filename)} skipped"
      end

      if keep_files
        new_name = filename.to_s.sub('out', 'processed')
        File.rename(filename, new_name)
      else
        File.unlink(filename)
      end

      if event
        if should_increase_sample_rate?(event)
          sample_rate = 1
        elsif should_decrease_sample_rate?(event)
          sample_rate = 5
        end

        events.push event
      end
    end
  rescue Magick::ImageMagickError => e
    KartLog.error "RMagick error #{e}"
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
  sleep(0.2)
end

