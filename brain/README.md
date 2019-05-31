# Kartistics Server

Along with the kartistics brain, this tracks position over time of Mario Kart players and rankings overtime.  Interface is into a slack channel - #kartistics

# How to use
After a race, go to the kartistics channel in slackbot and type:
`:kart: result 1st 2nd 3rd 4th`

Where 1st 2nd 3rd 4th are names of players.

# Rankings
Everyone starts with 0 points. You cannot go below 0. When a four person race happens, it is ranked using the trueskill algorithm

## Testing

> ./script/spec

## Running

Add a .env file with a slack webhook URL

> cp .env.example .env
> bundle
> bundle exec rails s
