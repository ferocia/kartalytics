require 'base64'

class IntroScreen < Screen
  COURSES = [
    {file: 'sunshine_airport', name: 'Sunshine Airport', glob: ""},
    {file: 'dolphin_shoals', name: 'Dolphin Shoals', glob: ""},
    {file: 'electrodrome', name: 'Electrodrome', glob: ""},
    {file: 'mount_wario', name: 'Mount Wario', glob: ""},

    {file: 'moo_moo_meadows', name: 'Moo Moo Meadows (Wii)', glob: ""},
    {file: 'mario_circuit_gba', name: 'Mario Circuit (GBA)', glob: ""},
    {file: 'cheep_cheep_beach', name: 'Cheep Cheep Beach (DS)', glob: ""},
    {file: 'toads_turnpike', name: 'Toad\'s Turnpike (N64)', glob: ""},

    {file: 'mario_circuit', name: 'Mario Circuit', glob: ""},
    {file: 'toad_harbor', name: 'Toad Harbor', glob: ""},
    {file: 'twisted_mansion', name: 'Twisted Mansion', glob: ""},
    {file: 'shy_guy_falls', name: 'Shy Guy Falls', glob: ""},

    {file: 'cloudtop_cruise', name: 'Cloudtop Cruise', glob: ""},
    {file: 'bone_dry_dunes', name: 'Bone Dry Dunes', glob: ""},
    {file: 'bowsers_castle', name: 'Bowser\'s Castle', glob: ""},
    {file: 'rainbow_road', name: 'Rainbow Road', glob: ""},

    {file: 'mario_kart_stadium', name: 'Mario Kart Stadium', glob: ""},
    {file: 'water_park', name: 'Water Park', glob: ""},
    {file: 'sweet_sweet_canyon', name: 'Sweet Sweet Canyon', glob: ""},
    {file: 'thwomp_ruins', name: 'Thwomp Ruins', glob: ""},

    {file: 'dry_dry_desert', name: 'Dry Dry Desert (GameCube)', glob: ""},
    {file: 'donut_plains_3', name: 'Donut Plains 3 (SNES)', glob: ""},
    {file: 'royal_raceway', name: 'Royal Raceway (N64)', glob: ""},
    {file: 'dk_jungle', name: 'DK Jungle (3DS)', glob: ""},

    {file: 'wario_stadium', name: 'Wario Stadium (DS)', glob: ""},
    {file: 'sherbet_land', name: 'Sherbet Land (GameCube)', glob: ""},
    {file: 'melody_motorway', name: 'Melody Motorway (3DS)', glob: ""},
    {file: 'yoshi_valley', name: 'Yoshi Valley (N64)', glob: ""},

    {file: 'tick_tock_clock', name: 'Tick-Tock Clock (DS)', glob: ""},
    {file: 'piranha_plant_slide', name: 'Piranha Plant Slide (3DS)', glob: ""},
    {file: 'grumble_volcano', name: 'Grumble Volcano (Wii)', glob: ""},
    {file: 'rainbow_road_n64', name: 'Rainbow Road (N64)', glob: "*"},

    {file: 'yoshi_circuit', name: 'Yoshi Circuit (GameCube)', glob: ""},
    {file: 'excitebike_arena', name: 'Excitebike Arena', glob: ""},
    {file: 'dragon_driftway', name: 'Dragon Driftway', glob: ""},
    {file: 'mute_city', name: 'Mute City', glob: ""},

    {file: 'warios_gold_mine', name: 'Wario’s Gold Mine (Wii)', glob: ""},
    {file: 'rainbow_road_snes', name: 'Rainbow Road (SNES)', glob: ""},
    {file: 'ice_ice_outpost', name: 'Ice Ice Outpost', glob: ""},
    {file: 'hyrule_circuit', name: 'Hyrule Circuit', glob: ""},

    {file: 'baby_park', name: 'Baby Park (GameCube)', glob: ""},
    {file: 'cheese_land', name: 'Cheese Land (GBA)', glob: ""},
    {file: 'wild_woods', name: 'Wild Woods', glob: ""},
    {file: 'animal_crossing', name: 'Animal Crossing', glob: ""},

    {file: 'koopa_city', name: 'Koopa City (3DS)', glob: ""},
    {file: 'ribbon_road', name: 'Ribbon Road (GBA)', glob: ""},
    {file: 'super_bell_subway', name: 'Super Bell Subway', glob: ""},
    {file: 'big_blue', name: 'Big Blue', glob: ""},

    {file: 'paris_promenade_tour', name: 'Paris Promenade (Tour)', glob: ""},
    {file: 'toad_circuit_3ds', name: 'Toad Circuit (3DS)', glob: ""},
    {file: 'choco_mountain_n64', name: 'Choco Mountain (N64)', glob: ""},
    {file: 'coconut_mall_wii', name: 'Coconut Mall (Wii)', glob: ""},

    {file: 'tokyo_blur_tour', name: 'Tokyo Blur (Tour)', glob: ""},
    {file: 'shroom_ridge_ds', name: 'Shroom Ridge (DS)', glob: ""},
    {file: 'sky_garden_gba', name: 'Sky Garden (GBA)', glob: ""},
    {file: 'ninja_hideaway', name: 'Ninja Hideaway', glob: ""},

    {file: 'new_york_minute_tour', name: 'New York Minute (Tour)', glob: ""},
    {file: 'mario_circuit_3_snes', name: 'Mario Circuit 3 (SNES)', glob: ""},
    {file: 'kalimari_desert_n64', name: 'Kalimari Desert (N64)', glob: ""},
    {file: 'waluigi_pinball_ds', name: 'Waluigi Pinball (DS)', glob: ""},

    {file: 'sydney_sprint_tour', name: 'Sydney Sprint (Tour)', glob: ""},
    {file: 'snow_land_gba', name: 'Snow Land (GBA)', glob: ""},
    {file: 'mushroom_gorge_wii', name: 'Mushroom Gorge (Wii)', glob: ""},
    {file: 'sky_high_sundae', name: 'Sky-High Sundae', glob: ""},
  ].each do |course|
    course[:images] = Dir.glob("reference_images/intro/#{course[:file]}#{course[:glob]}.jpg").map{|f|
      Phashion::Image.new(f)
    }
  end

  REFERENCE = Phashion::Image.new("reference_images/intro/intro_reference.jpg")

  def self.prepare_image(screenshot)
    crop = screenshot.original.dup.crop!(258, 620, 350, 36)
    image = crop.black_threshold(50000, 50000, 50000)
    crop.destroy!
    image
  end

  def self.matches_image?(screenshot)
    image = screenshot.original.dup.crop!(111, 589, 44, 37)

    phash = convert_to_phash(image)

    phash.distance_from(REFERENCE) < 10
  end

  def self.extract_event(screenshot)
    image = prepare_image(screenshot)
    image_base64 = Base64.strict_encode64(image.to_blob)
    phash = convert_to_phash(image)

    likely_course = COURSES.min_by{|c|
      c[:images].map{|i| phash.distance_from(i) }.min
    }

    # Debug
    # screenshot.original.write("#{likely_course[:file]}-#{image.distance_from(likely_course[:image])}-#{rand(256)}.jpg")

    if phash.distance_from(likely_course[:images].first) < 10
      {
        event_type: 'intro_screen',
        data: {
          course_name: likely_course[:name],
          image_base64: image_base64,
        }
      }
    else
      {
        event_type: 'intro_screen',
        data: {
          course_name: 'Unknown Course',
          image_base64: image_base64,
        }
      }
    end
  end
end
