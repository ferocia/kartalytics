# Kartalytics

Kartalytics is a project to in real time analyse Mario Kart 8 Deluxe matches as they're being played and then take action on that analysis.

It is comprised of 3 main parts:

## Recorder

Its function is to capture the input stream of Mario Kart and save it out as sequence of snapshots. To do this we'll use the following hardware:
  - HDMI splitter
  - HDMI to ethernet converter ([LKV373A](http://www.ebay.com.au/itm/LKV373A-V3-0-HDMI-Extender-100-120M-HDMI-Extender-Over-Cat5-Cat6-TCP-IP-based-/162287794299))
  - Raspberry Pi

We'll use the approach/software developed here:

https://github.com/benjojo/de-ip-hdmi/blob/master/main.go

https://blog.danman.eu/new-version-of-lenkeng-hdmi-over-ip-extender-lkv373a/)

## Analyser

Its function is to take the raw snapshot images and analyse them to determine what is happening in the image.  It is stateless and it simply populate an event stream with events such as:
  - Load screen
  - Main Menu
  - Race Start (race_name)
  - Race underway:
    - Player 1 (position: 6, items: [red shell, none], coins: 5)
    - etc
  - Race finish:
    - Player 1 (position: 2, points: 12)
  - View Results:
    - Player 1 (position: 3, points: 87)

## Brain

The brain is responsible for consuming the event stream and reconstituting those into a concept of Games/Players/Results etc.  As an example, the brain sees a series of race underway events then a "Main Menu" event, it should assume the game has been abandoned.  Likewise if it sees a series of Race Underway events then a Race Finish then a View Results it should assume a game has been completed.