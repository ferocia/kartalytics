import React, {useState} from 'react';
import {css} from '@emotion/react';
import {useQuery} from '@tanstack/react-query';
import isEqual from 'lodash/isEqual';
import request from 'lib/request';
import {useRecursiveTimeout} from 'hooks';
import DevTools from 'components/DevTools';
import CourseStats from 'components/CourseStats';
import FullScreenLoader from 'components/FullScreenLoader';
import PageHeader from 'components/PageHeader';
import RaceChart from 'components/RaceChart';
import ScoreChart from 'components/ScoreChart';
import Leaderboard from './Leaderboard';
import RaceDetails from './RaceDetails';
import Section from './Section';
import SelectPlayers from './SelectPlayers';
import Results from './Results';
import type {Entities} from 'types';

const UPDATE_TIMEOUT = 500;

function Event() {
  const [selectPlayers, setSelectPlayers] = useState<boolean>(false);
  const {data: event, refetch} = useQuery<Entities.Event>(
    ['event'],
    () => {
      return request('/api/kartalytics/event');
    },
    {
      isDataEqual: isEqual,
      notifyOnChangeProps: ['data'], // prevent unnecessary isFetching rerenders
    }
  );

  useRecursiveTimeout(refetch, UPDATE_TIMEOUT);

  function handleClickPlayer(e: React.MouseEvent) {
    if (event?.match?.assigned) return;

    e.preventDefault();
    setSelectPlayers(true);
  }

  function renderSideBar() {
    if (event == null) return null;
    const {race, match, title} = event;
    const leaderboard = match?.leaderboard;

    return (
      <div css={styles.sidebar}>
        {race && <RaceDetails title={title} race={race} />}
        {leaderboard && <Leaderboard leaderboard={leaderboard} onClickPlayer={handleClickPlayer} />}
        {leaderboard && <ScoreChart leaderboard={leaderboard} />}
      </div>
    );
  }

  const players = event?.race?.players;
  const race = event?.race;
  const top_records = race?.course_top_records;
  const top_players = race?.course_top_players;

  return event?.match?.assigned ? (
    <div css={styles.root}>
      <PageHeader />
      <Results {...event} match={event.match} />
    </div>
  ) : event?.match && (!event.match.started || selectPlayers) ? (
    <div css={[styles.root, styles.rootSingle]}>
      <PageHeader />
      <SelectPlayers leaderboard={event.match.leaderboard} onSubmit={() => setSelectPlayers(false)} />
    </div>
  ) : (
    <div css={styles.root}>
      <PageHeader />
      {renderSideBar()}
      <div css={styles.content}>
        {players ? (
          players[0].data.length && race != null ? (
            <Section title="Live Graph" component={<RaceChart race={race} />} />
          ) : top_records && top_players ? (
            <Section
              title="Course Statistics"
              component={<CourseStats topRecords={top_records} topPlayers={top_players} />}
            />
          ) : (
            <Section title="Waiting for race to start..." component={<FullScreenLoader />} />
          )
        ) : (
          <Section title="Waiting for game data..." component={<FullScreenLoader />} />
        )}
      </div>
    </div>
  );
}

export default function WrappedEvent() {
  return (
    <>
      <Event />
      {process.env.NODE_ENV !== 'production' && <DevTools />}
    </>
  );
}

const styles = {
  root: css`
    display: grid;
    grid-gap: 4rem;
    grid-template-areas:
      'header header'
      'aside content';
    grid-template-columns: 39rem 1fr;
    grid-template-rows: 10rem 1fr;
    min-height: 100vh;
    padding: 4rem;
  `,

  rootSingle: css`
    grid-template-areas:
      'header'
      'content';
    grid-template-columns: 1fr;
    grid-template-rows: 10rem 1fr;
  `,

  sidebar: css`
    display: flex;
    flex-direction: column;
    grid-area: aside;
  `,

  content: css`
    display: flex;
    flex-direction: column;
    grid-area: content;
  `,
};
