$LOAD_PATH.unshift File.join(File.dirname(__FILE__), "..")

require 'analyser'
require 'enumerable/statistics'
require 'ruby-prof'

times = []
prof = false

RubyProf.start if prof
# in race test screen
test_image = "2017062619484500-16851BE00BC6068871FE49D98876D6C5.jpg"
40.times do
  Dir["training-data/#{test_image}"].each do |f|
  # Dir["training-data/*.jpg"].each do |f|
    start_time = Time.now
    Analyser.analyse!(f)
    end_time = Time.now
    times.push(end_time - start_time)
  end
end
if prof
  result = RubyProf.stop
  printer = RubyProf::GraphHtmlPrinter.new(result)
  File.open("graph.html", "w") {|f| printer.print(f) }

  printer = RubyProf::CallStackPrinter.new(result)
  File.open("calls.html", "w") {|f| printer.print(f) }
end

puts "Count:   #{times.length}"
puts "Total:   #{times.sum}"
puts "Median:  #{times.median}"
puts "Mean:    #{times.mean}"
puts "Max:     #{times.max}"
