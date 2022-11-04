import React from 'react';
import {css} from '@emotion/react';
import {useQuery} from '@tanstack/react-query';
import request from 'lib/request';
import FullScreenLoader from '../../components/FullScreenLoader';
import PlayerList from '../../components/PlayerList';
import PageHeader from 'components/PageHeader';
import type {Entities} from 'types';

export default function Players() {
  const {data: players, isLoading} = useQuery<Entities.Player[]>(['players'], () => {
    return request('/api/kartalytics/players');
  });

  if (isLoading || players == null) {
    return <FullScreenLoader />;
  }

  return (
    <div css={styles.root}>
      <PageHeader />
      <PlayerList players={players} />
    </div>
  );
}

const styles = {
  root: css`
    align-items: center;
    display: flex;
    flex-direction: column;
    justify-content: center;
    padding: 4rem;
  `,
};
