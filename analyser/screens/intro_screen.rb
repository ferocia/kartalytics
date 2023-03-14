require 'base64'

class IntroScreen < Screen
  COURSES = [
    {file: 'sunshine_airport', name: 'Sunshine Airport', variant: :none},
    {file: 'dolphin_shoals', name: 'Dolphin Shoals', variant: :none},
    {file: 'electrodrome', name: 'Electrodrome', variant: :none},
    {file: 'mount_wario', name: 'Mount Wario', variant: :none},

    {file: 'moo_moo_meadows', name: 'Moo Moo Meadows (Wii)', variant: :none},
    {file: 'mario_circuit_gba', name: 'Mario Circuit (GBA)', variant: :gba},
    {file: 'cheep_cheep_beach', name: 'Cheep Cheep Beach (DS)', variant: :ds},
    {file: 'toads_turnpike', name: 'Toad\'s Turnpike (N64)', variant: :n64},

    {file: 'mario_circuit', name: 'Mario Circuit', variant: :none},
    {file: 'toad_harbor', name: 'Toad Harbor', variant: :none},
    {file: 'twisted_mansion', name: 'Twisted Mansion', variant: :none},
    {file: 'shy_guy_falls', name: 'Shy Guy Falls', variant: :none},

    {file: 'cloudtop_cruise', name: 'Cloudtop Cruise', variant: :none},
    {file: 'bone_dry_dunes', name: 'Bone Dry Dunes', variant: :none},
    {file: 'bowsers_castle', name: 'Bowser\'s Castle', variant: :none},
    {file: 'rainbow_road', name: 'Rainbow Road', variant: :none},

    {file: 'mario_kart_stadium', name: 'Mario Kart Stadium', variant: :none},
    {file: 'water_park', name: 'Water Park', variant: :none},
    {file: 'sweet_sweet_canyon', name: 'Sweet Sweet Canyon', variant: :none},
    {file: 'thwomp_ruins', name: 'Thwomp Ruins', variant: :none},

    {file: 'dry_dry_desert', name: 'Dry Dry Desert (GameCube)', variant: :gcn},
    {file: 'donut_plains_3', name: 'Donut Plains 3 (SNES)', variant: :snes},
    {file: 'royal_raceway', name: 'Royal Raceway (N64)', variant: :n64},
    {file: 'dk_jungle', name: 'DK Jungle (3DS)', variant: :"3ds"},

    {file: 'wario_stadium', name: 'Wario Stadium (DS)', variant: :ds},
    {file: 'sherbet_land', name: 'Sherbet Land (GameCube)', variant: :gcn},
    {file: 'melody_motorway', name: 'Melody Motorway (3DS)', variant: :"3ds"},
    {file: 'yoshi_valley', name: 'Yoshi Valley (N64)', variant: :n64},

    {file: 'tick_tock_clock', name: 'Tick-Tock Clock (DS)', variant: :ds},
    {file: 'piranha_plant_slide', name: 'Piranha Plant Slide (3DS)', variant: :"3ds"},
    {file: 'grumble_volcano', name: 'Grumble Volcano (Wii)', variant: :wii},
    {file: 'rainbow_road_n64', name: 'Rainbow Road (N64)', variant: :n64},

    {file: 'yoshi_circuit', name: 'Yoshi Circuit (GameCube)', variant: :gcn},
    {file: 'excitebike_arena', name: 'Excitebike Arena', variant: :none},
    {file: 'dragon_driftway', name: 'Dragon Driftway', variant: :none},
    {file: 'mute_city', name: 'Mute City', variant: :none},

    {file: 'warios_gold_mine', name: 'Wario’s Gold Mine (Wii)', variant: :wii},
    {file: 'rainbow_road_snes', name: 'Rainbow Road (SNES)', variant: :snes},
    {file: 'ice_ice_outpost', name: 'Ice Ice Outpost', variant: :none},
    {file: 'hyrule_circuit', name: 'Hyrule Circuit', variant: :none},

    {file: 'baby_park', name: 'Baby Park (GameCube)', variant: :gcn},
    {file: 'cheese_land', name: 'Cheese Land (GBA)', variant: :gba},
    {file: 'wild_woods', name: 'Wild Woods', variant: :none},
    {file: 'animal_crossing', name: 'Animal Crossing', variant: :none},

    {file: 'koopa_city', name: 'Koopa City (3DS)', variant: :"3ds"},
    {file: 'ribbon_road', name: 'Ribbon Road (GBA)', variant: :gba},
    {file: 'super_bell_subway', name: 'Super Bell Subway', variant: :none},
    {file: 'big_blue', name: 'Big Blue', variant: :none},

    {file: 'paris_promenade_tour', name: 'Paris Promenade (Tour)', variant: :tour},
    {file: 'toad_circuit_3ds', name: 'Toad Circuit (3DS)', variant: :"3ds"},
    {file: 'choco_mountain_n64', name: 'Choco Mountain (N64)', variant: :n64},
    {file: 'coconut_mall_wii', name: 'Coconut Mall (Wii)', variant: :wii},

    {file: 'tokyo_blur_tour', name: 'Tokyo Blur (Tour)', variant: :tour},
    {file: 'shroom_ridge_ds', name: 'Shroom Ridge (DS)', variant: :ds},
    {file: 'sky_garden_gba', name: 'Sky Garden (GBA)', variant: :gba},
    {file: 'ninja_hideaway', name: 'Ninja Hideaway', variant: :none},

    {file: 'new_york_minute_tour', name: 'New York Minute (Tour)', variant: :tour},
    {file: 'mario_circuit_3_snes', name: 'Mario Circuit 3 (SNES)', variant: :snes},
    {file: 'kalimari_desert_n64', name: 'Kalimari Desert (N64)', variant: :n64},
    {file: 'waluigi_pinball_ds', name: 'Waluigi Pinball (DS)', variant: :ds},

    {file: 'sydney_sprint_tour', name: 'Sydney Sprint (Tour)', variant: :tour},
    {file: 'snow_land_gba', name: 'Snow Land (GBA)', variant: :gba},
    {file: 'mushroom_gorge_wii', name: 'Mushroom Gorge (Wii)', variant: :wii},
    {file: 'sky_high_sundae', name: 'Sky-High Sundae', variant: :none},

    {file: 'london_loop_tour', name: 'London Loop (Tour)', variant: :tour},
    {file: 'boo_lake_gba', name: 'Boo Lake (GBA)', variant: :gba},
    {file: 'alpine_pass_3ds', name: 'Alpine Pass (3DS)', variant: :"3ds"},
    {file: 'maple_treeway_wii', name: 'Maple Treeway (Wii)', variant: :wii},

    {file: 'berlin_byways_tour', name: 'Berlin Byways (Tour)', variant: :tour},
    {file: 'peach_gardens_ds', name: 'Peach Gardens (DS)', variant: :ds},
    {file: 'merry_mountain', name: 'Merry Mountain', variant: :none},
    {file: 'rainbow_road_3ds', name: 'Rainbow Road (3DS)', variant: :"3ds"},

    {file: 'amsterdam_drift_tour', name: 'Amsterdam Drift (Tour)', variant: :tour},
    {file: 'riverside_park_gba', name: 'Riverside Park (GBA)', variant: :gba},
    {file: 'dks_snowboard_cross_wii', name: 'DK’s Snowboard Cross (Wii)', variant: :wii},
    {file: 'yoshis_island', name: 'Yoshi’s Island', variant: :none},

    {file: 'bangkok_rush_tour', name: 'Bangkok Rush (Tour)', variant: :tour},
    {file: 'mario_circuit_ds', name: 'Mario Circuit (DS)', variant: :ds},
    {file: 'waluigi_stadium_gcn', name: 'Waluigi Stadium (GCN)', variant: :gcn},
    {file: 'singapore_speedway_tour', name: "Singapore Speedway (Tour)", variant: :tour},
  ].each do |course|
      course[:image] = Phashion::Image.new("reference_images/intro/#{course[:file]}.jpg")
    end

  VARIANT_COURSES = COURSES.group_by {|course| course[:variant]}

  VARIANTS = VARIANT_COURSES.keys.map {|variant| { name: variant, image: Phashion::Image.new("reference_images/variants/#{variant}.jpg") } }

  REFERENCE = Phashion::Image.new("reference_images/intro/intro_reference.jpg")

  def self.process_image(im)
    processed = im.threshold(50000)
    im.destroy!
    processed
  end

  def self.prepare_image(screenshot)
    variant_crop = process_image(screenshot.original.dup.crop!(258, 638, 80, 18))
    track_crop = process_image(screenshot.original.dup.crop!(338, 620, 350, 36))

    [variant_crop, track_crop]
  end

  def self.matches_image?(screenshot)
    image = screenshot.original.dup.crop!(111, 589, 44, 37)

    phash = convert_to_phash(image)

    phash.distance_from(REFERENCE) < 10
  end

  def self.extract_event(screenshot)
    for_base64 = process_image(screenshot.original.dup.crop!(258, 620, 350, 36))
    image_base64 = Base64.strict_encode64(for_base64.to_blob)
    for_base64.destroy!

    variant_crop, track_crop = prepare_image(screenshot)

    variant_phash = convert_to_phash(variant_crop)
    track_phash = convert_to_phash(track_crop)

    variant = VARIANTS.min_by {|v| variant_phash.distance_from(v[:image]) }

    variant_courses = VARIANT_COURSES[variant[:name]]

    likely_course = variant_courses.min_by {|c|
      track_phash.distance_from(c[:image])
    }

    # Debug
    # screenshot.original.write("#{likely_course[:file]}-#{image.distance_from(likely_course[:image])}-#{rand(256)}.jpg")

    if track_phash.distance_from(likely_course[:image]) < 10
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
