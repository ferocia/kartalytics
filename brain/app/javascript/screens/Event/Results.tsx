import React from 'react';
import {css} from '@emotion/react';
import {formatDate} from 'lib/helpers';
import ScoreChart from 'components/ScoreChart';
import Leaderboard from 'components/MatchLeaderboard';
import Heading from 'components/Heading';
import trophy from 'images/trophy.gif';
import type {Entities} from 'types';

type Props = Omit<Entities.Event, 'match'> & {
  match: Entities.Match;
};

export default function Results({match: {created_at, id, leaderboard}}: Props) {
  const winnerImgSrc = leaderboard[0].image_url;

  return (
    <main css={styles.root}>
      <aside css={styles.sidebar}>
        <Heading>
          Match {id}, {formatDate(created_at)}
        </Heading>
        <Leaderboard css={styles.leaderboard} leaderboard={leaderboard} />
        <ScoreChart leaderboard={leaderboard} />
      </aside>
      <section css={styles.content}>
        <h2 css={styles.title}>Congratulations!</h2>
        {winnerImgSrc && <img css={styles.silhouette} src={winnerImgSrc} />}
        <img css={styles.trophy} src={trophy} alt="trophy" />
      </section>
    </main>
  );
}

const styles = {
  root: css`
    display: flex;
    grid-row-start: content;
    grid-column-start: aside;
    grid-row-end: content;
    grid-column-end: content;
  `,

  sidebar: css`
    flex: 1;
    display: flex;
    flex-direction: column;
  `,

  title: css`
    font: normal 6vw SuperMario;
    -webkit-text-stroke: 1.6rem rgba(0, 0, 0, 0.1);
  `,

  leaderboard: css`
    margin-top: 6rem;
    font-size: 1vw;
  `,

  content: css`
    position: relative;
    flex: 1.5;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: space-around;
  `,

  silhouette: css`
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    opacity: 0.2;
    object-fit: cover;
    object-position: cover;
    pointer-events: none;
  `,

  trophy: css`
    height: 65%;
  `,
};
