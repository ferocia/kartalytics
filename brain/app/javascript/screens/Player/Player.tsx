import React from 'react';
import {useParams} from 'react-router-dom';
import {css} from '@emotion/react';
import {useQuery} from '@tanstack/react-query';
import request from 'lib/request';
import FullScreenLoader from '../../components/FullScreenLoader';
import PageHeader from 'components/PageHeader';
import RivalTable from 'components/RivalTable';
import ScoresChart from 'components/ScoresChart';
import Heading from 'components/Heading';
import Match from 'screens/Home/Match'; // Need to move this to generic components folder
import * as colors from 'styles/colors';
import Achievements from './components/Achievements';
import Stats from './components/Stats';
import type {Entities} from 'types';

export default function Player() {
  const {name} = useParams();
  const {data: player, isLoading} = useQuery<Entities.ComplexPlayer>(['player', name], () => {
    return request(`/api/kartalytics/players/${name}`);
  });

  if (isLoading || player == null) {
    return <FullScreenLoader />;
  }

  return (
    <div css={styles.root}>
      <PageHeader />
      <div css={styles.content}>
        <div css={styles.header}>
          <div css={styles.player}>
            <img css={styles.image} src={player.image_url}></img>
            <div css={styles.row}>
              {player.leaderboard_position && (
                <p
                  css={[styles.subheading, styles.stat, podiumStyles(player.leaderboard_position)]}
                >{`#${player.leaderboard_position}`}</p>
              )}
              <Heading css={styles.name}>
                {player.on_fire ? '🔥' : null}
                {player.name}
              </Heading>
            </div>
          </div>
        </div>
        <Stats player={player} />
        <Achievements courses={player.courses} />
        {player.rival_results.length > 0 && (
          <>
            <Heading css={styles.subheading} level="2">
              vs rivals
            </Heading>
            <RivalTable rivalResults={player.rival_results} />
          </>
        )}
        {player.recent_scores.length > 0 && (
          <>
            <Heading css={styles.subheading} level="2">
              Recent scores
            </Heading>
            <ScoresChart scores={player.recent_scores} />
          </>
        )}
        {player.recent_matches.length > 0 && (
          <>
            <Heading css={styles.subheading} level="2">
              Recent matches
            </Heading>
            {player.recent_matches.map(match => (
              <Match key={match.id} {...match} />
            ))}
          </>
        )}
      </div>
    </div>
  );
}

function podiumStyles(position: number) {
  switch (position) {
    case 1:
      return css`
        color: ${colors.gold};
      `;
    case 2:
      return css`
        color: ${colors.silver};
      `;
    case 3:
      return css`
        color: ${colors.bronze};
      `;
  }
}

const styles = {
  root: css`
    align-items: center;
    display: flex;
    flex-direction: column;
    padding: 4rem;
  `,

  content: css`
    margin-top: 4em;
  `,

  header: css`
    align-items: center;
    display: flex;
    flex-direction: row;
    justify-content: center;
  `,

  image: css`
    background-color: rgba(255, 255, 255, 0.1);
    border-radius: 50% 50% 4px 4px;
    height: 200px;
  `,

  name: css`
    padding-top: 0.5em;
    padding-left: 0.33em;
  `,

  player: css`
    margin-right: 4em;
    text-align: center;
  `,

  stat: css`
    font-family: 'SuperMario';
    font-size: 5em;
    padding: 0;
  `,

  stats: css`
    display: flex;
    justify-content: space-between;
  `,

  subheading: css`
    margin-top: 2rem;
    padding: 2rem 0;
  `,

  row: css`
    align-items: center;
    display: flex;
    justify-content: center;
  `,
};
