require 'rqrcode'
require 'erb'

names = [
  'andi',
  'andrei',
  'andrew',
  'andy',
  'baha',
  'ben',
  'carson',
  'chendo',
  'chris',
  'christian',
  'david',
  'dbs',
  'dom',
  'doug',
  'eliza',
  'ev',
  'gall',
  'gt',
  'hannah',
  'higgs',
  'james',
  'jamieson',
  'jared',
  'jon',
  'juzzy',
  'langers',
  'levi',
  'lucas',
  'marcus',
  'mark',
  'matt',
  'mike',
  'neil',
  'raj',
  'sam',
  'samii',
  'stathis',
  'steve',
  'tarragon',
  'tom',
  'wernah',
  'xavier',
]

names.each do |name|
  qr = RQRCode::QRCode.new(name.to_s)
  File.write("output/#{name}.svg", qr.as_svg)
end

index_template = ERB.new(File.read('index.html.erb'))
File.write("output/index.html", index_template.result(binding))
