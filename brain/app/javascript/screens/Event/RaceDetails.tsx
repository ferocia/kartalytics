import React from 'react';
import {css} from '@emotion/react';
import {formatTime} from 'lib/helpers';
import Heading from 'components/Heading';
import CourseImage from 'components/CourseImage';
import CourseRecords from 'components/CourseRecords';
import type {Entities} from 'types';

type Props = {
  title: string;
  race: Required<Entities.Event>['race'];
};

export default function RaceDetails({
  title,
  race: {course_name, course_image, course_best_time, course_champion, players},
}: Props) {
  return (
    <div>
      <Heading level="2">{course_name}</Heading>
      <CourseImage imageUrl={course_image} />
      <Heading level="2" color="orange">
        {title}
        <CourseRecords players={players} />
      </Heading>
      <Heading level="2" color="orange" css={styles.bestTime}>
        {course_champion && `Champion: ${course_champion} (${formatTime(course_best_time)})`}
      </Heading>
    </div>
  );
}

const styles = {
  bestTime: css`
    padding-top: 1rem;
  `,
};
