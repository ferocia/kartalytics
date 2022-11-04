import React, {useEffect, useState, useMemo} from 'react';
import {css} from '@emotion/react';
import {useQuery} from '@tanstack/react-query';
import * as colors from 'styles/colors';
import request from 'lib/request';
import PlayerList from '../../components/PlayerList';
import beesechurger from 'images/beesechurger.svg';
import nullSrc from 'images/players/null.png';
import defaultSrc from 'images/players/default.png';
import type {Entities} from 'types';

type LeaderboardPlayer = Entities.MatchLeaderboard[number];

type Props = {
  leaderboard: Entities.MatchLeaderboard;
  onSubmit: () => void;
};

export default function SelectPlayers({leaderboard, onSubmit}: Props) {
  const [selectedPlayer, setSelectedPlayer] = useState<null | LeaderboardPlayer>(null);
  const [focusedPlayer, setFocusedPlayer] = useState<number>(0);

  const {data: selectPlayers} = useQuery<Entities.EventSelectPlayers>(['selectPlayers'], () => {
    return request('/api/kartalytics/event_select_players');
  });

  useEffect(() => {
    const handleKeyDown = (event: KeyboardEvent) => {
      if (selectedPlayer != null && event.code === 'Escape') {
        event.preventDefault();
        setSelectedPlayer(null);
      }

      const matches = event.code.match(/Digit([1-4])/);
      if (selectedPlayer == null && matches != null) {
        event.preventDefault();
        setSelectedPlayer(leaderboard[Number(matches[1]) - 1]);
      }
    };

    document.addEventListener('keydown', handleKeyDown);

    return () => document.removeEventListener('keydown', handleKeyDown);
  }, [leaderboard, selectedPlayer, setSelectedPlayer]);

  function handleSubmit(player: LeaderboardPlayer, name: string) {
    const event = {
      event_type: 'players_present',
      timestamp: new Date().toISOString(),
      data: {
        ...leaderboard.reduce((acc, curr) => ({...acc, [curr.player]: {name: curr.name}}), {}),
        [player.player]: {name},
      },
    };

    fetch('/api/kartalytics/ingest', {
      method: 'post',
      headers: {'content-type': 'application/json'},
      body: JSON.stringify({events: [event]}),
    }).catch(e => {
      // hey
    });

    onSubmit();
  }

  function handleSelectPlayer(player: Entities.Player) {
    if (selectedPlayer == null) return;

    handleSubmit(selectedPlayer, player.name);
    setSelectedPlayer(null);
  }

  if (selectPlayers == null) return null;
  const {players, show_double_down, previous_matches_in_a_row} = selectPlayers;

  return selectedPlayer == null ? (
    <section css={styles.root}>
      {show_double_down && <DoubleDown matchesInARow={previous_matches_in_a_row} />}
      {sortLeaderboard(leaderboard).map((player, index) => (
        <PlayerCard
          {...player}
          autoFocus={focusedPlayer === index}
          index={index}
          key={player.player}
          onClick={_ => setSelectedPlayer(player)}
          onFocus={_ => setFocusedPlayer(index)}
        />
      ))}
    </section>
  ) : (
    <PlayerList
      css={styles.playerList}
      hoverStyles={{color: colors.black, background: selectedPlayer.color}}
      onSelectPlayer={handleSelectPlayer}
      players={[...players, {id: 0, name: 'null', image_url: nullSrc}]}
    />
  );
}

type PlayerCardProps = LeaderboardPlayer & {
  autoFocus: boolean;
  index: number;
  onClick: (event: React.MouseEvent<HTMLButtonElement>) => void;
  onFocus: (event: React.FocusEvent<HTMLButtonElement>) => void;
};

function PlayerCard({autoFocus, color, image_url, index, name, onClick, onFocus}: PlayerCardProps) {
  return (
    <button
      autoFocus={autoFocus}
      css={[
        styles.player,
        {
          background: color,
          outlineColor: color,
          opacity: isAssigned(name) ? 1 : 0.5,
        },
      ]}
      onClick={onClick}
      onFocus={onFocus}
    >
      <h2 css={styles.position}>Player {index + 1}</h2>
      <h3 css={styles.name}>{isAssigned(name) ? name : 'Select ▾'}</h3>
      <span css={[styles.avatar, {backgroundImage: `url(${image_url ?? defaultSrc})`}]} />
    </button>
  );
}

function DoubleDown({matchesInARow}: {matchesInARow: number}) {
  function handleClick() {
    fetch('/api/kartalytics/double-down', {method: 'put'});
  }

  const phrase = useMemo(() => {
    switch (matchesInARow) {
      case 1:
        return 'double down';
      case 2:
        return 'triple down';
      case 3:
        return 'quadruple down';
      case 4:
        return 'quintuple down';
      case 5:
        return 'sextuple down';
      case 6:
        return 'septuple down';
      case 7:
        return 'octuple down';
      case 8:
        return 'nonuple down';
      case 9:
        return 'decuple down';
      default:
        return `play a ${matchesInARow}th`;
    }
  }, [matchesInARow]);

  return (
    <button css={styles.doubleDown} onClick={handleClick}>
      <img src={beesechurger} /> {phrase}
    </button>
  );
}

function isAssigned(name: string) {
  return !/player\s/i.test(name);
}

function sortLeaderboard<T extends Entities.MatchLeaderboard>(leaderboard: T): T {
  const players = ['player_one', 'player_two', 'player_three', 'player_four'] as const;
  return leaderboard.sort((a, b) => players.indexOf(a.player) - players.indexOf(b.player));
}

const styles = {
  root: css`
    display: grid;
    grid-gap: 6rem;
    grid-template-areas:
      'p1 p2'
      'p3 p4';
    grid-template-columns: 1fr 1fr;
    grid-template-rows: 1fr 1fr;
    padding: 2rem;
  `,

  player: css`
    border: none;
    border-bottom: 0.1em solid rgba(0, 0, 0, 0.3);
    border-top: 0.1em solid rgba(255, 255, 255, 0.4);
    border-radius: 0.2em;
    position: relative;
    padding: 0.75em;
    font-size: 4vw;
    color: ${colors.shark};
    text-shadow: 0 0.05em rgba(255, 255, 255, 0.3);
    cursor: pointer;
    text-align: left;

    &:hover {
      transform: scale(1.02);
    }

    &:focus {
      outline-offset: 1.5rem;
      outline-style: solid;
      outline-width: 0.5rem;
    }
  `,

  position: css`
    font-family: 'SuperMario';
    font-size: 6vw;
  `,

  avatar: css`
    background-position: bottom center;
    background-repeat: no-repeat;
    background-size: contain;
    position: absolute;
    bottom: 0;
    right: 0;
    width: 5.75em;
    height: 5.75em;
    pointer-events: none;
  `,

  name: css`
    margin-top: 0.5em;
    font-weight: bold;
  `,

  select: css`
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    appearance: none;
    opacity: 0;
    font-size: 2rem;
  `,

  doubleDown: css`
    position: absolute;
    top: 6rem;
    left: 6rem;
    display: flex;
    align-items: center;
    background: transparent;
    border: none;
    cursor: pointer;
    color: ${colors.white};
    font-size: 2rem;
    font-weight: bold;
    font-style: italic;
    z-index: 15;

    img {
      width: 6rem;
      height: 6rem;
      margin-right: 0.5em;
    }

    &:hover {
      transform: rotate(-5deg) scale(1.1);
    }
  `,

  playerList: css`
    margin-top: -1rem;
  `,
};
