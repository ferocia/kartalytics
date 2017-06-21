require './analyser'

Dir.glob('./training-data/*.jpg').each do |filename|
  Analyser.analyse!(filename)
end