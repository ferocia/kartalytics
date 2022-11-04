import React from 'react';
import {css} from '@emotion/react';
import RaceChart from 'components/RaceChart';
import Heading from 'components/Heading';
import CourseImage from 'components/CourseImage';
import * as colors from 'styles/colors';
import type {Entities} from 'types';

type Props = {
  race: Entities.ComplexMatch['races'][number];
  index: number;
};

export default function Race({index, race: {id, course_name, course_image_url, chart}}: Props) {
  return (
    <div css={styles.root} id={`race${id}`}>
      <Heading level="2">
        {' '}
        Race {index + 1} -{' '}
        <div css={styles.course}>
          {course_name}
          <div css={styles.courseImageContainter}>
            <div css={styles.courseImage}>
              <CourseImage imageUrl={course_image_url} />
            </div>
          </div>
        </div>
      </Heading>

      <div css={styles.chart}>
        <RaceChart race={chart} />
      </div>
    </div>
  );
}

const styles = {
  root: css`
    display: flex;
    flex-direction: column;
    margin: 0.5rem 0 5rem;
  `,

  courseImageContainter: css`
    display: none;
    position: absolute;
    top: 3rem;
    z-index: 1;

    &::before {
      background: ${colors.orange};
      content: ' ';
      height: 4rem;
      left: 43%;
      position: absolute;
      top: 1rem;
      transform: rotate(45deg);
      width: 4rem;
    }
  `,

  courseImage: css`
    position: relative;
    width: 30rem;
  `,

  course: css`
    border-bottom: 0.1rem dotted rgba(255, 255, 255, 0.1);
    color: rgba(255, 255, 255, 0.6);
    cursor: pointer;
    display: inline-block;
    font-weight: normal;
    position: relative;

    &:hover {
      color: rgba(255, 255, 255, 0.8);

      & div {
        display: block;
      }
    }
  `,

  chart: css`
    display: flex;
    height: calc((100vw - 16rem) / 2);
  `,
};
