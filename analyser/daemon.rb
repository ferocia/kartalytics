require './analyser'
glob = "dump/best*.jpg"

loop do
  Dir.glob(glob).each do |filename|
    event = Analyser.analyse!(filename)

    puts "#{File.basename(filename)} => #{event.inspect}"
    File.rename(filename, filename.to_s.sub('best', 'processed'))
  end
  sleep(0.2)
end

