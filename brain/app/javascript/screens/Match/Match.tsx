import React from 'react';
import {useParams} from 'react-router-dom';
import {css} from '@emotion/react';
import {useQuery} from '@tanstack/react-query';
import request from 'lib/request';
import FullScreenLoader from 'components/FullScreenLoader';
import Details from './Details';
import Races from './Races';
import type {Entities} from 'types';

export default function Match() {
  const {id} = useParams();
  const {data: match} = useQuery<Entities.ComplexMatch>(['match', id], () => {
    return request(`/api/kartalytics/match/${id}`);
  });

  return match ? (
    <div css={styles.root}>
      <Details match={match} />
      <Races races={match.races} />
    </div>
  ) : (
    <FullScreenLoader />
  );
}

const styles = {
  root: css`
    display: flex;
    padding: 4rem;
  `,
};
