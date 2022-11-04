import React, {useEffect, useRef} from 'react';
import {css} from '@emotion/react';
import {debounce} from 'lodash';
import Chart from './score-chart';
import * as colors from 'styles/colors';
import type {Entities} from 'types';

type Props = {
  leaderboard: Entities.MatchLeaderboard;
};

export default function ScoreChart(props: Props) {
  const chart = useRef<Chart>();
  const chartEl = useRef<SVGSVGElement>(null);

  useEffect(() => {
    if (chartEl.current == null) {
      throw Error('chartEl is not assigned');
    }

    chart.current = new Chart(chartEl.current, props);

    const handleWindowResize = () => chart.current?.handleResize();
    const debouncedHandleWindowResize = debounce(handleWindowResize, 150);
    window.addEventListener('resize', debouncedHandleWindowResize);

    return () => {
      debouncedHandleWindowResize.cancel();
      window.removeEventListener('resize', debouncedHandleWindowResize);
    };
  }, []);

  useEffect(() => {
    chart.current?.handleUpdate(props);
  }, [props.leaderboard]);

  return (
    <div css={styles.root}>
      <svg ref={chartEl} />
    </div>
  );
}

const styles = {
  root: css`
    display: flex;
    flex: 1;
    margin-top: 2rem;

    svg {
      flex: 1;
    }

    .axis {
      text {
        fill: rgba(255, 255, 255, 0.6);
        font-size: 1.6rem;
      }

      line,
      path {
        stroke: rgba(255, 255, 255, 0.1);
      }
    }
  `,
};
