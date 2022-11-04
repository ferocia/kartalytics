import React from 'react';
import {css} from '@emotion/react';
import {Link} from 'react-router-dom';
import {formatDate} from 'lib/helpers';
import Player from './Player';
import * as colors from 'styles/colors';
import type {Entities} from 'types';

type Props = Entities.Match;

export default function Match({created_at, id, leaderboard}: Props) {
  return (
    <Link css={styles.link} to={`/kartalytics_matches/${id}`}>
      <div css={styles.root}>
        <div css={styles.date}>{formatDate(created_at)}</div>
        <div css={styles.players}>
          {leaderboard.map((player, index) => (
            <Player {...player} key={`${id}-${player.name}`} showCrown={index === 0} />
          ))}
        </div>
      </div>
    </Link>
  );
}

const styles = {
  root: css`
    background-color: #141414;
    border-radius: 0.6rem;
    margin-bottom: 2rem;
    padding: 3rem;

    &:hover {
      background-color: rgba(255, 255, 255, 0.1);
    }
  `,

  date: css`
    color: white;
    font-size: 1.6rem;
    margin-bottom: 1.2rem;
    text-align: right;
    width: 100%;
  `,

  link: css`
    text-decoration: none;
  `,

  players: css`
    display: flex;
  `,
};
