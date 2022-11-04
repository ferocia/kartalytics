import React, {useState} from 'react';
import {css, type CSSObject} from '@emotion/react';
import escapeRegExp from 'lodash/escapeRegExp';
import {Link} from 'react-router-dom';
import * as colors from 'styles/colors';
import SearchBar from './SearchBar';
import type {Entities} from 'types';

type Props = {
  className?: string;
  hoverStyles?: CSSObject;
  onSelectPlayer?: (player: Entities.Player) => void;
  players: Entities.Player[];
};

export default function PlayerList({className, hoverStyles, onSelectPlayer, players}: Props) {
  const [searchValue, setSearchValue] = useState('');
  const [showRetired, setShowRetired] = useState(false);

  function handleInput(event: React.ChangeEvent<HTMLInputElement>) {
    setSearchValue(event.target.value);
  }

  function handleKeyPress(event: React.KeyboardEvent<HTMLInputElement>) {
    if (event.key === 'Enter' && filteredPlayers.length > 0) {
      event.preventDefault();
      onSelectPlayer?.(filteredPlayers[0]);
    }
  }

  function handleClickPlayer(player: Entities.Player, event: React.MouseEvent<HTMLAnchorElement>) {
    if (onSelectPlayer == null) return;

    event.preventDefault();
    onSelectPlayer(player);
  }

  function handleClickShowRetired() {
    window.scrollTo({top: 0});
    setShowRetired(true);
  }

  const filteredPlayers = players
    .filter(({name}) => new RegExp(escapeRegExp(searchValue), 'i').test(name))
    .filter(({retired}) => (showRetired ? true : !retired));

  return (
    <div className={className} css={styles.root}>
      <SearchBar
        onInput={handleInput}
        onKeyPress={handleKeyPress}
        placeholder="Search by player name"
        value={searchValue}
      />
      <div css={styles.content}>
        {filteredPlayers.map(player => (
          <Link
            css={[styles.link, hoverStyles && {'&:hover': hoverStyles}]}
            key={player.id}
            onClick={event => handleClickPlayer(player, event)}
            to={`/players/${player.name}`}
          >
            <img css={styles.img} src={player.image_url} width="256" height="236" />
            <p css={styles.name}>{player.name}</p>
          </Link>
        ))}
      </div>
      {!showRetired && (
        <button css={styles.showRetired} onClick={handleClickShowRetired}>
          Show retired players ({players.filter(({retired}) => retired).length})
        </button>
      )}
    </div>
  );
}

const styles = {
  root: css`
    width: 100%;
    margin-top: 3rem;
  `,

  content: css`
    display: grid;
    width: 100%;
    padding: 4rem 0;
    grid-gap: 4rem;
    grid-template-columns: repeat(auto-fill, 16rem);
    justify-content: center;
    font-size: 2em;
  `,

  img: css`
    width: 14rem;
    height: auto;
  `,

  name: css`
    padding: 1rem 0;
  `,

  link: css`
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: flex-end;
    background-color: #141414;
    color: white;
    border-radius: 0.6rem;
    text-decoration: none;
    transition: background-color 100ms, transform 100ms;

    &:hover {
      background-color: rgba(255, 255, 255, 0.1);
      transform: scale(1.06);
    }
  `,

  showRetired: css`
    display: block;
    padding: 1.5rem 2rem;
    margin: 2rem auto;
    width: auto;
    background: ${colors.orange};
    color: ${colors.white};
    text-align: center;
    font-size: 2rem;
    border-radius: 0.6rem;
    border: none;
    cursor: pointer;

    &:hover {
      opacity: 0.8;
    }
  `,
};
