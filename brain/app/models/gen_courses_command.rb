# frozen_string_literal: true

class GenCoursesCommand < Command
  def self.create_track(cup, name, image, db_name = name)
    { name: name, cup: cup, image: image, db_name: db_name }
  end

  # go here for new track details: https://mariokart.fandom.com/wiki/Mario_Kart_8_Deluxe#Courses
  TRACKS = [
    create_track('Mushroom', 'Mario Kart Stadium', "https://static.wikia.nocookie.net/mariokart/images/f/f0/MK8-_Mario_Kart_Stadium.png"),
    create_track('Mushroom', 'Water Park', "https://static.wikia.nocookie.net/mariokart/images/9/92/MK8-_Water_Park.png"),
    create_track('Mushroom', 'Sweet Sweet Canyon', "https://static.wikia.nocookie.net/mariokart/images/1/16/MK8-_Sweet_Sweet_Canyon.png"),
    create_track('Mushroom', 'Thwomp Ruins', "https://static.wikia.nocookie.net/mariokart/images/a/a0/MK8-_Thwomp_Ruins.png"),

    create_track('Flower', 'Mario Circuit', "https://static.wikia.nocookie.net/mariokart/images/0/0b/MK8-_Mario_Circuit.png"),
    create_track('Flower', 'Toad Harbour', "https://static.wikia.nocookie.net/mariokart/images/1/1a/MK8-_Toad_Harbor.png", "Toad Harbor"),
    create_track('Flower', 'Twisted Mansion', "https://static.wikia.nocookie.net/mariokart/images/9/9a/MK8-_Twisted_Mansion.png"),
    create_track('Flower', 'Shy Guy Falls', "https://static.wikia.nocookie.net/mariokart/images/e/e8/MK8-_Shy_Guy_Falls.png"),

    create_track('Star', 'Sunshine Airport', "https://static.wikia.nocookie.net/mariokart/images/b/b5/MK8-_Sunshine_Airport.png"),
    create_track('Star', 'Dolphin Shoals', "https://static.wikia.nocookie.net/mariokart/images/3/35/MK8-_Dolphin_Shoals.png"),
    create_track('Star', 'Electrodrome', "https://static.wikia.nocookie.net/mariokart/images/e/e9/MK8-_Electrodrome.png"),
    create_track('Star', 'Mount Wario', "https://static.wikia.nocookie.net/mariokart/images/b/b1/MK8-_Mount_Wario.png"),

    create_track('Special', 'Cloudtop Cruise', "https://static.wikia.nocookie.net/mariokart/images/2/2b/MK8-_Cloudtop_Cruise.png"),
    create_track('Special', 'Bone-Dry Dunes', "https://static.wikia.nocookie.net/mariokart/images/1/14/MK8-_Bone-Dry_Dunes.png", "Bone Dry Dunes"),
    create_track('Special', "Bowser's Castle", "https://static.wikia.nocookie.net/mariokart/images/8/85/MK8-_Bowser%27s_Castle.png"),
    create_track('Special', 'Rainbow Road (Wii U)', "https://static.wikia.nocookie.net/mariokart/images/3/37/MK8-_Rainbow_Road.png", "Rainbow Road"),

    create_track('Egg', 'Yoshi Circuit (GameCube)', "https://static.wikia.nocookie.net/mariokart/images/c/c4/MK8-DLC-Course-icon-GCN_YoshiCircuit.png"),
    create_track('Egg', 'Excitebike Arena', "https://static.wikia.nocookie.net/mariokart/images/8/83/MK8-DLC-Course-icon-ExcitebikeArena.png"),
    create_track('Egg', 'Dragon Driftway', "https://static.wikia.nocookie.net/mariokart/images/a/ab/MK8-DLC-Course-icon-DragonDriftway.png"),
    create_track('Egg', 'Mute City', "https://static.wikia.nocookie.net/mariokart/images/6/6f/MK8-DLC-Course-icon-MuteCity.png"),

    create_track('Crossing', 'Baby Park (GameCube)', "https://static.wikia.nocookie.net/mariokart/images/e/e0/MK8-DLC-Course-icon-GCN_BabyPark.png"),
    create_track('Crossing', 'Cheese Land (GBA)', "https://static.wikia.nocookie.net/mariokart/images/9/94/MK8-DLC-Course-icon-GBA_CheeseLand.png"),
    create_track('Crossing', 'Wild Woods', "https://static.wikia.nocookie.net/mariokart/images/3/3c/MK8-DLC-Course-icon-WildWoods.png"),
    create_track('Crossing', 'Animal Crossing', "https://static.wikia.nocookie.net/mariokart/images/d/dc/MK8-DLC-Course-icon-AnimalCrossing.png"),

    create_track('Shell', 'Moo Moo Meadows (Wii)', "https://static.wikia.nocookie.net/mariokart/images/d/da/MK8-_Wii_Moo_Moo_Meadows.png"),
    create_track('Shell', 'Mario Circuit (GBA)', "https://static.wikia.nocookie.net/mariokart/images/5/50/MK8-_GBA_Mario_Circuit.png"),
    create_track('Shell', 'Cheep Cheep Beach (DS)', "https://static.wikia.nocookie.net/mariokart/images/f/fe/MK8-_DS_Cheep_Cheep_Beach.png"),
    create_track('Shell', "Toad's Turnpike (N64)", "https://static.wikia.nocookie.net/mariokart/images/7/75/MK8-_N64_Toad%27s_Turnpike.png"),

    create_track('Banana', 'Dry Dry Desert (GameCube)', "https://static.wikia.nocookie.net/mariokart/images/f/f1/MK8-_GCN_Dry_Dry_Desert.png"),
    create_track('Banana', 'Donut Plains 3 (SNES)', "https://static.wikia.nocookie.net/mariokart/images/b/b4/MK8-_SNES_Donut_Plains_3.png"),
    create_track('Banana', 'Royal Raceway (N64)', "https://static.wikia.nocookie.net/mariokart/images/a/a0/MK8-_N64_Royal_Raceway.png"),
    create_track('Banana', 'DK Jungle (3DS)', "https://static.wikia.nocookie.net/mariokart/images/5/5f/MK8-_3DS_DK_Jungle.png"),

    create_track('Leaf', 'Wario Stadium (DS)', "https://static.wikia.nocookie.net/mariokart/images/3/3f/MK8-_DS_Wario_Stadium.png"),
    create_track('Leaf', 'Sherbet Land (GameCube)', "https://static.wikia.nocookie.net/mariokart/images/6/67/MK8-_GCN_Sherbet_Land.png"),
    create_track('Leaf', 'Melody Motorway (3DS)', "https://static.wikia.nocookie.net/mariokart/images/e/e4/MK8-_3DS_Music_Park.png"),
    create_track('Leaf', 'Yoshi Valley (N64)', "https://static.wikia.nocookie.net/mariokart/images/f/fc/MK8-_N64_Yoshi_Valley.png"),

    create_track('Lightning', "Tick-Tock Clock (DS)", "https://static.wikia.nocookie.net/mariokart/images/d/d9/MK8-_DS_Tick-Tock_Clock.png"),
    create_track('Lightning', "Piranha Plant Pipeway", "https://static.wikia.nocookie.net/mariokart/images/c/ce/MK8-_3DS_Piranha_Plant_Slide.png", "Piranha Plant Slide (3DS)"),
    create_track('Lightning', "Grumble Volcano (Wii)", "https://static.wikia.nocookie.net/mariokart/images/e/ea/MK8-_Wii_Grumble_Volcano.png"),
    create_track('Lightning', "Rainbow Road (N64)", "https://static.wikia.nocookie.net/mariokart/images/5/5a/MK8-_N64_Rainbow_Road.png"),

    create_track('Triforce', "Wario's Gold Mine (Wii)", "https://static.wikia.nocookie.net/mariokart/images/e/e5/MK8-DLC-Course-icon-Wii_Wario%27sGoldMine.png"),
    create_track('Triforce', "Rainbow Road (SNES)", "https://static.wikia.nocookie.net/mariokart/images/6/6d/MK8-DLC-Course-icon-SNES_RainbowRoad.png"),
    create_track('Triforce', "Ice Ice Outpost", "https://static.wikia.nocookie.net/mariokart/images/f/f6/MK8-DLC-Course-icon-IceIceOutpost.png"),
    create_track('Triforce', "Hyrule Circuit", "https://static.wikia.nocookie.net/mariokart/images/e/e6/MK8-DLC-Course-icon-HyruleCircuit.png", "Hyrule Circuit"),

    create_track('Bell', "Koopa City (3DS)", "https://static.wikia.nocookie.net/mariokart/images/b/b4/MK8-DLC-Course-icon-3DS_NeoBowserCity.png"),
    create_track('Bell', "Ribbon Road (GBA)", "https://static.wikia.nocookie.net/mariokart/images/7/78/MK8-DLC-Course-icon-GBA_RibbonRoad.png"),
    create_track('Bell', "Super Bell Subway", "https://static.wikia.nocookie.net/mariokart/images/b/bd/MK8-DLC-Course-icon-SuperBellSubway.png"),
    create_track('Bell', "Big Blue", "https://static.wikia.nocookie.net/mariokart/images/9/9b/MK8-DLC-Course-icon-BigBlue.png"),

    create_track('Golden Dash', "Paris Promenade", "https://static.wikia.nocookie.net/mariokart/images/e/ec/Paris_Promenade_Icon_%288_Deluxe%29.png"),
    create_track('Golden Dash', "Toad Circuit", "https://static.wikia.nocookie.net/mariokart/images/3/36/Toad_Circuit_Icon_%288_Deluxe%29.png"),
    create_track('Golden Dash', "Choco Mountain", "https://static.wikia.nocookie.net/mariokart/images/1/1e/Choco_Mountain_Icon_%288_Deluxe%29.png"),
    create_track('Golden Dash', "Coconut Mall", "https://static.wikia.nocookie.net/mariokart/images/8/8b/Coconut_Mall_Icon_%288_Deluxe%29.png"),

    create_track('Lucky Cat', "Tokyo Blur", "https://static.wikia.nocookie.net/mariokart/images/1/17/Tokyo_Blur_Icon_%288_Deluxe%29.png"),
    create_track('Lucky Cat', "Shroom Ridge", "https://static.wikia.nocookie.net/mariokart/images/4/44/Shroom_Ridge_Icon_%288_Deluxe%29.png"),
    create_track('Lucky Cat', "Sky Garden", "https://static.wikia.nocookie.net/mariokart/images/9/90/Sky_Garden_Icon_%288_Deluxe%29.png"),
    create_track('Lucky Cat', "Ninja Hideaway", "https://static.wikia.nocookie.net/mariokart/images/f/fe/Ninja_Hideaway_Icon_%288_Deluxe%29.png"),
  ]

  def execute
    has_electrodrome = false
    formatted = random_tracks.each_with_index.map do |track, race|
      emoji = ":#{track[:cup].gsub(" ", "_")}_cup:".downcase
      if track[:name] == "Electrodrome"
        has_electrodrome = true
      end

      text = ["#{race + 1}. #{emoji} #{track[:name]}"]

      db_course = KartalyticsCourse.find_by(name: track[:db_name])
      if db_course.present? && db_course.fastest_race.present?
        text << "Fastest time: #{db_course.best_time}s by #{db_course.champion.name}"
      end

      block = {
        type: "section",
        text: {
          type: "mrkdwn",
          text: text.join("\n")
        },
        accessory: {
          type: "image",
          image_url: track[:image],
          alt_text: "Track image for #{track[:name]}"
        }
      }

      block
    end

    body = <<~EOF
      *Tracks to play*:

      #{formatted.map { |x| x[:text][:text] }.join("\n")}
    EOF

    blocks = [
      {
        type: "header",
        text: {
          type: "plain_text",
          text: "Tracks to play",
        }
      },
      *formatted,
    ]

    if has_electrodrome
      blocks << {
        type: "image",
        image_url: "https://user-images.githubusercontent.com/4755785/135799099-86b0a74c-5169-4d4b-bb55-a4aeba0f241c.jpg",
        alt_text: "It's always Electrodrome"
      }
    end

    { type: :raw, text: body, blocks: blocks }
  end

  def random_tracks
    TRACKS.sample(6)
  end

  def to_test
    out = TRACKS.map { |track| ["#{track[:cup]} - #{track[:name]}", 0] }.to_h

    100000.times do
      random_tracks.each do |track|
        name = "#{track[:cup]} - #{track[:name]}"
        out[name] += 1
      end
    end

    puts "Track,Count"
    out.each do |k, v|
      puts "#{k},#{v}"
    end
  end
end
