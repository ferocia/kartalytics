require 'pry'

require './analyser'

LOWER_Y_OFFSET = 360

SMALL_ITEM = [34, 34]
LARGE_ITEM = [61, 61]

LEFT_SMALL_X = 49
UPPER_SMALL_Y = 32

LEFT_LARGE_X = 89
UPPER_LARGE_Y = 52

LOWER_SMALL_Y = UPPER_SMALL_Y + LOWER_Y_OFFSET
LOWER_LARGE_Y = UPPER_LARGE_Y + LOWER_Y_OFFSET

RIGHT_SMALL_X = 1197
RIGHT_LARGE_X = 1130


P1_SMALL = [LEFT_SMALL_X, UPPER_SMALL_Y, *SMALL_ITEM]
P1_LARGE = [LEFT_LARGE_X, UPPER_LARGE_Y, *LARGE_ITEM]

P2_SMALL = [RIGHT_SMALL_X, UPPER_SMALL_Y, *SMALL_ITEM]
P2_LARGE = [RIGHT_LARGE_X, UPPER_LARGE_Y, *LARGE_ITEM]

P3_SMALL = [LEFT_SMALL_X, LOWER_SMALL_Y, *SMALL_ITEM]
P3_LARGE = [LEFT_LARGE_X, LOWER_LARGE_Y, *LARGE_ITEM]

P4_SMALL = [RIGHT_SMALL_X, LOWER_SMALL_Y, *SMALL_ITEM]
P4_LARGE = [RIGHT_LARGE_X, LOWER_LARGE_Y, *LARGE_ITEM]

ITEM_LOCATIONS = {
  p1_small: P1_SMALL,
  p1_large: P1_LARGE,

  p2_small: P2_SMALL,
  p2_large: P2_LARGE,

  p3_small: P3_SMALL,
  p3_large: P3_LARGE,

  p4_small: P4_SMALL,
  p4_large: P4_LARGE,
}

PLAYER_HUE = {
  p1: 60,
  p2: 180,
  p3: 350,
  p4: 95,
}

ITEM_DETECTION_COORDS = {
  p1: [[64,   32], [118,  47]],
  p2: [[1214, 32], [1160, 47]],
  p3: [[65, 392], [118, 407]],
  p4: [[1214, 392], [1160, 407]],
}

def get_corner_pixels(img, x, y, w, h)
  tl = [x, y]
  tr = [x + w, y]
  bl = [x + w, y]
  br = [x + w, y + h]

  [tl, tr, bl, br].map do |(x, y)|
    img.pixel_color(x, y)
  end
end

def is_similar_colour?(px1, px2)
  hd_thr = 20
  s_thr = 120
  h1, s1, l1, _ = px1.to_hsla
  h2, s2, l2, _ = px2.to_hsla

  hd = (h1 - h2).abs
  sd = (s1 - s2).abs
  if hd < hd_thr || hd > (360 - hd_thr) # account for 360 edge
    if s1 > 120 && s2 > 120
      return true
    end
  end
  false
end

Dir.glob('./training-data-2/race3*.jpg').each_with_index do |screen, index|
  img = Magick::Image.read(screen).first

  ITEM_LOCATIONS.each do |k, l|
    path = "items/#{k}_#{File.basename(screen, '.jpg')}.jpg"
    player = k.to_s[0...2].to_sym

    if coords = ITEM_DETECTION_COORDS[player]
      pixels = coords.map { |(x, y)| img.pixel_color(x, y).to_hsla }
      if pixels.count { |(h, s, l, a)| l > 180 && s < 150 } < 2
        next
      end
    else
      next
    end

    pixels = get_corner_pixels(img, *l)
    first, *others = pixels
    count = others.count { |px| is_similar_colour?(first, px) }
    puts "#{path}\t#{k}"

    if count >= 2 && pixels.all? { |px| px.to_hsla[1] > 50 }
      crop_delta = if l.last == 34
        [6, 6, -12, -12]
        [10, 10, -20, -20]
      else
        [15, 15, -30, -30]
        # [20, 10, -40, -20]
      end
      cropped = img.crop(*(l.zip(crop_delta).map { |a, b| a + b}))
      cropped.write(path)
      cropped.destroy!

      # cropped = img.crop(*l)
      # cropped.write("items/#{k}_#{File.basename(screen, '.jpg')}_f.jpg")
      # cropped.destroy!
    end
  end

  img.destroy!
end
