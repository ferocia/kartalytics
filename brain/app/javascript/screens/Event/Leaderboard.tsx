import React from 'react';
import {css} from '@emotion/react';
import Heading from 'components/Heading';
import Leaderboard from 'components/MatchLeaderboard';
import type {Entities} from 'types';

type Props = {
  leaderboard: Entities.MatchLeaderboard;
  onClickPlayer: (event: React.MouseEvent) => void;
};

export default function EventLeaderboard({leaderboard, onClickPlayer}: Props) {
  return (
    <div css={styles.root}>
      <Heading level="2">Overall Leaderboard</Heading>
      <Leaderboard leaderboard={leaderboard} onClickPlayer={onClickPlayer} />
    </div>
  );
}

const styles = {
  root: css`
    margin-top: 3rem;
  `,
};
