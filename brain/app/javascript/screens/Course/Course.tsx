import React from 'react';
import {useParams} from 'react-router-dom';
import {css} from '@emotion/react';
import {useQuery} from '@tanstack/react-query';
import request from 'lib/request';
import FullScreenLoader from '../../components/FullScreenLoader';
import PageHeader from 'components/PageHeader';
import Heading from 'components/Heading';
import * as colors from 'styles/colors';
import type {Entities} from 'types';
import PlayerTopTimesBarChart from './components/PlayerTopTimesBarChart';
import TopPlayersPieChart from './components/TopPlayersPieChart';
import CourseStats from 'components/CourseStats';
import CourseImage from 'components/CourseImage';

export default function Course() {
  const {name} = useParams();
  const {data: course, isLoading} = useQuery<Entities.ComplexCourse>(['courses', name], () => {
    return request(`/api/kartalytics/courses/${name}`);
  });

  if (isLoading || course == null) return <FullScreenLoader />;

  return (
    <div css={styles.root}>
      <PageHeader />
      <div css={styles.content}>
        <div css={styles.header}>
          <div css={styles.player}></div>
        </div>

        <div css={styles.image}>
          <CourseImage imageUrl={course.image} />
        </div>

        <div css={styles.charts}>
          <Heading css={[styles.stat, styles.colorBlue]} level="2">
            Top Times
          </Heading>
          <PlayerTopTimesBarChart players={course.uniq_top_records} />

          <Heading css={[styles.stat, styles.colorYellow]} level="2">
            Top Players
          </Heading>
          <TopPlayersPieChart players={course.top_players} />
        </div>

        <div css={styles.courseStats}>
          <CourseStats topRecords={course.uniq_top_records} topPlayers={course.top_players} showPercentage={false} />
        </div>
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
    margin-top: 4em;
    width: 76rem;
  `,

  charts: css`
    width: 66%;
    margin: 0 auto;
  `,

  courseStats: css`
    margin-top: 6rem;
  `,

  header: css`
    align-items: center;
    display: flex;
    flex-direction: row;
    justify-content: center;
  `,

  image: css`
    position: relative;
    width: 50rem;
    margin: 0 auto;
  `,

  name: css`
    padding-top: 0.5em;
    padding-left: 0.33em;
  `,

  player: css`
    margin-right: 4em;
    text-align: center;
  `,

  stats: css`
    display: flex;
    justify-content: space-between;
  `,

  stat: css`
    font-family: 'SuperMario';
    font-size: 4.8rem;
    color: rgb(93, 251, 60);
    padding: 2.4rem 0;
  `,

  green: css`
    color: rgb(93, 251, 60);
  `,

  colorBlue: css`
    color: ${colors.blue};
  `,

  colorYellow: css`
    color: ${colors.yellow};
  `,
};
