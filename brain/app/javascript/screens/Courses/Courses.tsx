import React from 'react';
import {css} from '@emotion/react';
import {useQuery} from '@tanstack/react-query';
import request from 'lib/request';
import FullScreenLoader from '../../components/FullScreenLoader';
import CourseList from './components/CourseList';
import PageHeader from 'components/PageHeader';
import type {Entities} from 'types';

export default function Courses() {
  const {data: courses, isLoading} = useQuery<Entities.Course[]>(['courses'], () => {
    return request('/api/kartalytics/courses');
  });

  if (isLoading || courses == null) {
    return <FullScreenLoader />;
  }

  return (
    <div css={styles.root}>
      <PageHeader />
      <CourseList courses={courses} />
    </div>
  );
}

const styles = {
  root: css`
    align-items: center;
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
    justify-content: center;
    padding: 4rem;
  `,
};
