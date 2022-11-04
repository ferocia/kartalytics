import React from 'react';
import {css} from '@emotion/react';
import {useQuery} from '@tanstack/react-query';
import request from 'lib/request';
import FullScreenLoader from '../../components/FullScreenLoader';
import PageHeader from 'components/PageHeader';
import {Player, Players} from './components/Players';
import type {Entities} from 'types';

export default function Leaderboard() {
  const {data: leaderboard, isLoading} = useQuery<Entities.Player[]>(['leaderboard'], () => {
    return request('/api/kartalytics/leaderboard');
  });

  if (isLoading || leaderboard == null) {
    return <FullScreenLoader />;
  }

  return (
    <div css={styles.root}>
      <PageHeader />
      <div css={styles.content}>
        <Players>
          {leaderboard.map((player, index) => (
            <Player {...player} key={player.id} position={index + 1} />
          ))}
        </Players>
      </div>
    </div>
  );
}

const styles = {
  root: css`
    align-items: center;
    display: flex;
    flex-direction: column;
    padding: 4rem;
  `,

  content: css`
    padding: 4rem 0;
  `,
};
