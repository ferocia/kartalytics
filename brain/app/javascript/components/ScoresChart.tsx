import * as d3 from 'd3';
import React from 'react';
import {css} from '@emotion/react';
import * as colors from 'styles/colors';
import BarChart from 'components/BarChart';

type Props = {
  scores: number[];
};

export default function ScoresChart({scores}: Props) {
  return (
    <div css={styles.root}>
      <BarChart width={700} height={300} data={scores} />
    </div>
  );
}

const styles = {
  root: css`
    background-color: rgba(255, 255, 255, 0.1);
    border-radius: 0.6rem;
    padding: 3rem;
    min-width: 760px;
  `,
};
