require 'zbar'
require 'set'
require 'time'
require 'json'
require 'uri'
require 'net/http'

raise('You must set a POST_URL env variable') if ENV['POST_URL'].nil?

def analyse(qr_codes)
  return nil unless qr_codes.length == 4

  by_x = qr_codes.sort_by { |q| q[:x] }
  by_y = qr_codes.sort_by { |q| q[:y] }

  top_row = by_y[0..1].to_set
  bottom_row = by_y[2..].to_set
  left_column = by_x[0..1].to_set
  right_column = by_x[2..].to_set

  {
    player_one: (top_row & left_column).to_a.first&.fetch(:data),
    player_two: (top_row & right_column).to_a.first&.fetch(:data),
    player_three: (bottom_row & left_column).to_a.first&.fetch(:data),
    player_four: (bottom_row & right_column).to_a.first&.fetch(:data),
  }
end

def submit(players)
  payload =
    {
      events: [
        {
          event_type: 'players_present',
          data: {
            player_one: {
              name: players[:player_one]
            },
            player_two: {
              name: players[:player_two]
            },
            player_three: {
              name: players[:player_three]
            },
            player_four: {
              name: players[:player_four]
            },
          },
          timestamp: Time.now.iso8601(3)
        }
      ]
    }

  uri = URI.parse(ENV['POST_URL'])
  header = {'Content-Type': 'application/json'}

  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Post.new(uri.request_uri, header)
  request.body = payload.to_json

  response = http.request(request)

  unless response.code == '200'
    puts response.message
    puts response.body
  end
end

loop do
  puts '---'
  filename = 'tmp/snapshot.jpg'
  system ("rm -f #{filename}")
  system("imagesnap -q -w 1 -d 'C922 Pro Stream Webcam' #{filename}")

  qr_codes =
    ZBar::Image.from_jpeg(File.binread(filename))
      .process
      .filter { |r| r.symbology == 'QR-Code' }
      .map do |r|
        {
          x: r.location.map { |l| l[0] }.sum / 4.0,
          y: r.location.map { |l| l[1] }.sum / 4.0,
          data: r.data
        }
      end

  players = analyse(qr_codes)

  if players
    puts "player_one:   #{players[:player_one]}"
    puts "player_two:   #{players[:player_two]}"
    puts "player_three: #{players[:player_three]}"
    puts "player_four:  #{players[:player_four]}"
    submit(players)
  else
    puts 'No players found.'
  end
rescue StandardError => e
  puts e.message
ensure
  sleep 5
end
