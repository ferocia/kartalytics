require './analyser'

thresholds = {
  'golden-mushroom' => 16,
  'star' => 16,
  'banana' => 15,
  'banana-double' => 15,
  'banana-triple' => 15,
  'coin' => 15,
  'mushroom-double' => 14,
  'pirhana-plant' => 14,
  'fire-flower' => 15,
  'bullet' => 14,
  'green-shell' => 14,
}
thresholds.default = 13 # max

items = Hash[
  Dir['reference_images/items/*.jpg'].map do |f|
    [File.basename(f, '.jpg'), Phashion::Image.new(f)]
  end.sort_by { |(n, _)| thresholds[n] }
]


Dir['items/*.jpg'].each do |f|
  found = false
  items.each do |name_variant, ref_img|
    dist = ref_img.distance_from(Phashion::Image.new(f))
    name, variant = name_variant.split('_', 2)
    if dist < thresholds[name]
      p [f, name, variant, dist]
      FileUtils.mkdir_p("classified_items/#{name}/")
      FileUtils.copy(f, "classified_items/#{name}/#{variant}_#{dist}_#{File.basename(f)}")
      found = true
      break
    end
  end
  if !found
    FileUtils.mkdir_p("classified_items/unknown")
    FileUtils.copy(f, "classified_items/unknown/")
  end
end
