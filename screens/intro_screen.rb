class IntroScreen < Screen
  COURSES = [
    {file: 'sunshine_airport', name: 'Sunshine Airport'},
    {file: 'dolphin_shoals', name: 'Dolphin Shoals'},
    {file: 'electrodrome', name: 'Electrodrome'},
    {file: 'mount_wario', name: 'Mount Wario'},

    {file: 'moo_moo_meadows', name: 'Moo Moo Meadows (Wii)'},
    {file: 'mario_circuit_gba', name: 'Mario Circuit (GBA)'},
    {file: 'cheep_cheep_beach', name: 'Cheep Cheep Beach (DS)'},
    {file: 'toads_turnpike', name: 'Toad\'s Turnpike (N64)'},

    {file: 'mario_circuit', name: 'Mario Circuit'},
    {file: 'toad_harbor', name: 'Toad Harbor'},
    {file: 'twisted_mansion', name: 'Twisted Mansion'},
    {file: 'shy_guy_falls', name: 'Shy Guy Falls'},

    {file: 'cloudtop_cruise', name: 'Cloudtop Cruise'},
    {file: 'bone-dry_dunes', name: 'Bone-Dry Dunes'},
    {file: 'bowsers_castle', name: 'Bowser\'s Castle'},
    {file: 'rainbow_road', name: 'Rainbow Road'},

    {file: 'mario_kart_stadium', name: 'Mario Kart Stadium'},
    {file: 'water_park', name: 'Water Park'},
    {file: 'sweet_sweet_canyon', name: 'Sweet Sweet Canyon'},
    {file: 'thwomp_ruins', name: 'Thwomp Ruins'},

    {file: 'dry_dry_desert', name: 'Dry Dry Desert (GameCube)'},
    {file: 'donut_plains_3', name: 'Donut Plains 3 (SNES)'},
    {file: 'royal_raceway', name: 'Royal Raceway (N64)'},
    {file: 'dk_jungle', name: 'DK Jungle (3DS)'},

    {file: 'wario_stadium', name: 'Wario Stadium (DS)'},
    {file: 'sherbet_land', name: 'Sherbet Land (GameCube)'},
    {file: 'music_park', name: 'Music Park (3DS)'},
    {file: 'yoshi_valley', name: 'Yoshi Valley (N64)'},

    {file: 'tick_tock_clock', name: 'Tick-Tock Clock (DS)'},
    {file: 'piranha_plant_slide', name: 'Piranha Plant Slide (3DS)'},
    {file: 'grumble_volcano', name: 'Grumble Volcano (Wii)'},
    {file: 'rainbow_road_n64', name: 'Rainbow Road (N64)'},

    {file: 'yoshi_circuit', name: 'Yoshi Circuit (GameCube)'},
    {file: 'excitebike_arena', name: 'Excitebike Arena'},
    {file: 'dragon_driftway', name: 'Dragon Driftway'},
    {file: 'mute_city', name: 'Mute City'},

    {file: 'warios_gold_mine', name: 'Wario’s Gold Mine (Wii)'},
    {file: 'rainbow_road_snes', name: 'Rainbow Road (SNES)'},
    {file: 'ice_ice_outpost', name: 'Ice Ice Outpost'},
    {file: 'hyrule_circuit', name: 'Hyrule Circult'},

    {file: 'baby_park', name: 'Baby Park (GameCube)'},
    {file: 'cheese_land', name: 'Cheese Land (GBA)'},
    {file: 'wild_woods', name: 'Wild Woods'},
    {file: 'animal_crossing', name: 'Animal Crossing'},

    {file: 'neo_bowser_city', name: 'Neo Bowser City (3DS)'},
    {file: 'ribbon_road', name: 'Ribbon Road (GBA)'},
    {file: 'super_bell_subway', name: 'Super Bell Subway'},
    {file: 'big_blue', name: 'Big Blue'}
  ].each do |course|
    course[:image] = Phashion::Image.new("reference_images/intro/#{course[:file]}.jpg")
  end

  REFERENCE = Phashion::Image.new("reference_images/intro/intro_reference.jpg")

  def self.matches_image?(screenshot)
    image = screenshot.original.dup.crop!(111, 589, 44, 37)

    phash = convert_to_phash(image)

    phash.distance_from(REFERENCE) < 10
  end

  def self.extract_event(screenshot)
    crop = screenshot.original.dup.crop!(258, 620, 350, 36)
    image = crop.black_threshold(50000, 50000, 50000)
    crop.destroy!

    phash = convert_to_phash(image)

    likely_course = COURSES.min_by do |course|
      phash.distance_from(course[:image])
    end

    # Debug
    # screenshot.original.write("#{likely_course[:file]}-#{image.distance_from(likely_course[:image])}-#{rand(256)}.jpg")

    if phash.distance_from(likely_course[:image]) < 10
      {
        event_type: 'intro_screen',
        data: {
          course_name: likely_course[:name]
        }
      }
    end
  end
end