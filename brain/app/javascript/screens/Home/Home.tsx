import React, {useEffect} from 'react';
import {css} from '@emotion/react';
import {useInfiniteQuery} from '@tanstack/react-query';
import {useInView} from 'react-intersection-observer';
import request from 'lib/request';
import CurrentMatchButton from './CurrentMatchButton';
import Match from './Match';
import PageHeader from 'components/PageHeader';
import yoshi from 'images/yoshi.gif';
import type {Entities} from 'types';

type FetchMatchesResponse = {
  current_match: Entities.Match;
  matches: Entities.Match[];
};

async function fetchMatches({pageParam = 1}) {
  return request(`/api/kartalytics/matches?page=${pageParam}`);
}

export default function Home() {
  const [loadMoreRef, inView] = useInView();
  const {data, fetchNextPage, hasNextPage, isFetching} = useInfiniteQuery<FetchMatchesResponse>(
    ['home'],
    fetchMatches,
    {
      getNextPageParam: (lastPage, pages) => {
        return lastPage.matches.length ? pages.length + 1 : undefined;
      },
    }
  );

  useEffect(() => {
    if (inView) fetchNextPage();
  }, [inView, fetchNextPage]);

  return (
    <div css={styles.root}>
      <PageHeader />
      <div css={styles.content}>
        {data?.pages[0].current_match != null && <CurrentMatchButton />}
        {data?.pages.map(page => {
          return page.matches.map(match => <Match key={match.id} {...match} />);
        })}
        {data == null || hasNextPage ? (
          <div css={styles.loadingMore} ref={loadMoreRef}>
            {isFetching && <img src={yoshi} />}
          </div>
        ) : (
          <div css={styles.noMoreMatches}>No more matches</div>
        )}
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
    padding: 4rem 0;
  `,

  loadingMore: css`
    display: flex;
    justify-content: center;
    width: 100%;
  `,

  noMoreMatches: css`
    font-size: 1.2rem;
    margin: 6rem 0;
    text-align: center;
    width: 100%;
  `,
};
