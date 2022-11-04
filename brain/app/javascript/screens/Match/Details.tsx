import React from 'react';
import {css} from '@emotion/react';
import {formatDate} from 'lib/helpers';
import Leaderboard from 'components/MatchLeaderboard';
import ScoreChart from 'components/ScoreChart';
import Heading from 'components/Heading';
import type {Entities} from 'types';

type Props = {
  match: Entities.ComplexMatch;
};

export default function Details({match}: Props) {
  return (
    <div css={styles.root}>
      <Heading>Match {match.id}</Heading>
      <p css={styles.date}>{formatDate(match.created_at)}</p>

      <Leaderboard leaderboard={match.leaderboard} />
      <ScoreChart leaderboard={match.leaderboard} />
    </div>
  );
}

const styles = {
  root: css`
    position: fixed;
    width: 30rem;
  `,

  date: css`
    color: rgba(255, 255, 255, 0.3);
    font-size: 1.4rem;
    margin: 1.4rem 0 2.4rem;
  `,
};
