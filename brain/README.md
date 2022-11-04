![ci](https://github.com/Ferocia/kartalytics/workflows/brain/badge.svg?branch=main)

# Kartistics Server

Along with the kartistics brain, this tracks position over time of Mario Kart players and rankings overtime.  Interface is into a slack channel - #kartistics

# How to use

After a race, go to the kartistics channel in slackbot and type:
`:kart: result 1st 2nd 3rd 4th`

Where 1st 2nd 3rd 4th are names of players.

# Rankings

Everyone starts with 0 points. You cannot go below 0. When a four person race happens, it is ranked using the trueskill algorithm

## Development

Bootstrap if necessary.

> ./script/bootstrap

Bootstrapping doesn't reset the DB because it's common to load the prod DB locally. However, if you'd like a fresh slate, run the `db:reset` task.

> bin/rails db:reset

Run the devserver. This boots bin/webpack-dev-server & bin/rails.

> ./script/devserver

Then visit [localhost:3000/event](http://localhost:3000/event)

In development mode you can simulate events from the analyser by clicking Rocky Wrench (bottom-right) and selecting the desired event. Check `KartalyticsState` to understand how the state machine responds to these events.

Alternatively, you can make `/event` serve up fake data by setting the
`KARTALYTICS_EVENT_STUB` environment variable, for ease of facilitating UI
fixes. That may not be what you want: see `Resources::Kartalytics` for the
switch.

## Testing

> bin/rspec

Feature specs run headless by default. To bring up a browser, set DEFAULT_DRIVER to selenium_chrome.

> DEFAULT_DRIVER=selenium_chrome bin/rspec spec/features

## Running

> bin/rails s
