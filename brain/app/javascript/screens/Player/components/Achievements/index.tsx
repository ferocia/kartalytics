import * as React from 'react';
import {css} from '@emotion/react';
import Heading from 'components/Heading';
import type {Entities} from 'types';
import TrackBadges from './TrackBadges';

type Props = {
  courses: Entities.Course[];
};

export default function RivalTable({courses}: Props) {
  const completedTracks = courses.map(GetCourses);
  return (
    <>
      <Heading css={styles.subheading} level="2">
        Achievements
      </Heading>
      <div css={styles.root}>
        <TrackBadges completedTracks={completedTracks}></TrackBadges>
      </div>
    </>
  );
}

function GetCourses(course: {id: number; name: string}) {
  return course.name;
}

const styles = {
  root: css`
    background-color: rgba(255, 255, 255, 0.1);
    border-radius: 0.6rem;
    padding: 3rem;
    max-width: 76rem;
  `,

  subheading: css`
    margin-top: 2rem;
    padding: 2rem 0;
  `,
};
