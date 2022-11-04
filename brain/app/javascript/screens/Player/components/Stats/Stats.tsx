import * as React from 'react';
import {css} from '@emotion/react';
import Heading from 'components/Heading';
import {type Entities} from 'types';

type Props = Readonly<{player: Entities.ComplexPlayer}>;

export default function Stats({player}: Props) {
  return (
    <>
      <Heading css={styles.subheading} level="2">
        Stats
      </Heading>
      <div css={styles.root}>
        <div css={styles.statContainer}>
          <Heading level="3">Total matches:</Heading>
          <p css={styles.stat}>{player.number_of_matches}</p>
        </div>
        <div css={styles.statContainer}>
          <Heading level="3">Average score:</Heading>
          <p css={styles.stat}>{player.average_score}</p>
        </div>
        {player.perfect_matches > 0 && (
          <div css={styles.statContainer}>
            <Heading level="3">Perfect matches:</Heading>
            <p css={styles.stat}>{player.perfect_matches}</p>
          </div>
        )}
        {player.course_records > 0 && (
          <div css={styles.statContainer}>
            <Heading level="3">Course records:</Heading>
            <p css={styles.stat}>{player.course_records}</p>
          </div>
        )}
      </div>
    </>
  );
}

const styles = {
  root: css`
    background-color: rgba(255, 255, 255, 0.1);
    border-radius: 0.6rem;
    padding: 3rem;
    display: flex;
    width: 100%;
    max-width: 76rem;
    flex-wrap: wrap;
  `,

  content: css`
    margin-top: 4em;
  `,

  header: css`
    align-items: center;
    display: flex;
    flex-direction: row;
    padding-bottom: 4rem;
    justify-content: center;
  `,

  image: css`
    background-color: rgba(255, 255, 255, 0.1);
    border-radius: 50% 50% 4px 4px;
    height: 20rem;
  `,

  name: css`
    padding-top: 0.5em;
  `,

  player: css`
    margin-right: 4em;
    text-align: center;
  `,

  stat: css`
    font-family: 'SuperMario';
    font-size: 5rem;
    padding: 0;
    width: 20rem;
    margin-top: 1rem;
  `,

  statContainer: css`
    align-items: center;
    text-align: center;
    display: flex;
    flex-direction: column;
    width: 15rem;
    margin: 1rem;
  `,

  subheading: css`
    padding: 2rem 0;
  `,
};
