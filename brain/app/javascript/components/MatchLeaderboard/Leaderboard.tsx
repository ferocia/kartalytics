import React from 'react';
import {css} from '@emotion/react';
import Player from './Player';
import * as colors from 'styles/colors';
import type {Entities} from 'types';

type Props = {
  className?: string;
  leaderboard: Entities.MatchLeaderboard;
  onClickPlayer?: (event: React.MouseEvent) => void;
};

export default function Leaderboard({className, leaderboard, onClickPlayer}: Props) {
  const highestScore = leaderboard[0].score;
  return (
    <div className={className} css={styles.root}>
      {leaderboard.map((player, index) => (
        <Player
          key={player.player}
          {...player}
          onClick={onClickPlayer}
          position={player.position || index + 1}
          showCrown={player.score > 0 && player.score === highestScore}
        />
      ))}
    </div>
  );
}

const styles = {
  root: css`
    color: ${colors.black};
    margin: 2rem 0;
    font-size: 1rem;
  `,
};
