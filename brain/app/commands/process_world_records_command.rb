require 'nokogiri'

class ProcessWorldRecordsCommand
  def self.run(input)
    new(input).run
  end

  WR_NAME_TO_INTERNAL_NAME = {
    "3DS DK Jungle"           => "DK Jungle (3DS)",
    "3DS Music Park"          => "Melody Motorway (3DS)",
    "3DS Neo Bowser City"     => "Koopa City (3DS)",
    "3DS Piranha Plant Slide" => "Piranha Plant Slide (3DS)",
    "3DS Toad Circuit"        => "Toad Circuit (3DS)",
    "Animal Crossing"         => "Animal Crossing",
    "Big Blue"                => "Big Blue",
    "Bone-Dry Dunes"          => "Bone Dry Dunes",
    "Bowser's Castle"         => "Bowser's Castle",
    "Cloudtop Cruise"         => "Cloudtop Cruise",
    "Dolphin Shoals"          => "Dolphin Shoals",
    "Dragon Driftway"         => "Dragon Driftway",
    "DS Cheep Cheep Beach"    => "Cheep Cheep Beach (DS)",
    "DS Shroom Ridge"         => "Shroom Ridge (DS)",
    "DS Tick-Tock Clock"      => "Tick-Tock Clock (DS)",
    "DS Waluigi Pinball"      => "Waluigi Pinball (DS)",
    "DS Wario Stadium"        => "Wario Stadium (DS)",
    "Electrodrome"            => "Electrodrome",
    "Excitebike Arena"        => "Excitebike Arena",
    "GBA Cheese Land"         => "Cheese Land (GBA)",
    "GBA Mario Circuit"       => "Mario Circuit (GBA)",
    "GBA Ribbon Road"         => "Ribbon Road (GBA)",
    "GBA Sky Garden"          => "Sky Garden (GBA)",
    "GBA Snow Land"           => "Snow Land (GBA)",
    "GCN Baby Park"           => "Baby Park (GameCube)",
    "GCN Dry Dry Desert"      => "Dry Dry Desert (GameCube)",
    "GCN Sherbet Land"        => "Sherbet Land (GameCube)",
    "GCN Yoshi Circuit"       => "Yoshi Circuit (GameCube)",
    "Hyrule Circuit"          => "Hyrule Circuit",
    "Ice Ice Outpost"         => "Ice Ice Outpost",
    "Mario Circuit"           => "Mario Circuit",
    "Mario Kart Stadium"      => "Mario Kart Stadium",
    "Mount Wario"             => "Mount Wario",
    "Mute City"               => "Mute City",
    "N64 Choco Mountain"      => "Choco Mountain (N64)",
    "N64 Kalimari Desert"     => "Kalimari Desert (N64)",
    "N64 Rainbow Road"        => "Rainbow Road (N64)",
    "N64 Royal Raceway"       => "Royal Raceway (N64)",
    "N64 Toad's Turnpike"     => "Toad's Turnpike (N64)",
    "N64 Yoshi Valley"        => "Yoshi Valley (N64)",
    "Rainbow Road"            => "Rainbow Road",
    "Shy Guy Falls"           => "Shy Guy Falls",
    "Sky-High Sundae"         => "Sky-High Sundae",
    "SNES Donut Plains 3"     => "Donut Plains 3 (SNES)",
    "SNES Mario Circuit 3"    => "Mario Circuit 3 (SNES)",
    "SNES Rainbow Road"       => "Rainbow Road (SNES)",
    "Sunshine Airport"        => "Sunshine Airport",
    "Super Bell Subway"       => "Super Bell Subway",
    "Sweet Sweet Canyon"      => "Sweet Sweet Canyon",
    "Thwomp Ruins"            => "Thwomp Ruins",
    "Toad Harbor"             => "Toad Harbor",
    "Tour New York Minute"    => "New York Minute (Tour)",
    "Tour Ninja Hideaway"     => "Ninja Hideaway",
    "Tour Paris Promenade"    => "Paris Promenade (Tour)",
    "Tour Sydney Sprint"      => "Sydney Sprint (Tour)",
    "Tour Tokyo Blur"         => "Tokyo Blur (Tour)",
    "Twisted Mansion"         => "Twisted Mansion",
    "Water Park"              => "Water Park",
    "Wii Coconut Mall"        => "Coconut Mall (Wii)",
    "Wii Grumble Volcano"     => "Grumble Volcano (Wii)",
    "Wii Moo Moo Meadows"     => "Moo Moo Meadows (Wii)",
    "Wii Mushroom Gorge"      => "Mushroom Gorge (Wii)",
    "Wii Wario's Gold Mine"   => "Wario’s Gold Mine (Wii)",
    "Wild Woods"              => "Wild Woods",
  }

  def initialize
    @input = Nokogiri::HTML(URI.open("https://mkwrs.com/mk8dx/wrs_200.php"))
  end

  def run
    input
      .uniq
      .each do |record|
        name = WR_NAME_TO_INTERNAL_NAME[record[:name]]
        time = record[:time]
        KartalyticsCourse.find_by(name: name).update(world_record_time: time)
      end
  end

  def input
    @processed_input ||= begin
      record_rows = @input.at('table.wr').search('tr')[1..-2] # ignore header and total rows
      record_rows.map do |row|
        cells = row.search('td')
        name = cells[0].text
        time_parts = cells[1].text.split("'")
        minutes = time_parts[0].to_f
        seconds = time_parts[1].gsub("\"", ".").to_f
        time = ((minutes * 60) + seconds).round(3)
        {name: name, time: time}
      end
    end
  end
end
